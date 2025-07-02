import Entities
import Database
import Models
import Foundation
import Utilities

// MARK: - RatesDBServiceInterface

public protocol RatesDBServiceInterface {
    func saveRates(_ rates: [Rate], baseCurrency: String) async throws
    func fetchRateBy(toCurrencyCode: String, fromCurrencyCode: String) async throws -> Rate?
}

// MARK: - RatesDBService

final class RatesDBService {
    // MARK: - Private Properties

    private let databaseClient: DatabaseClientInterface

    // MARK: - Init

    init(databaseClient: DatabaseClientInterface) {
        self.databaseClient = databaseClient
    }

    // MARK: - Private Methods

    private func updateRates(existingRates: [RateEntity], actualRates: [Rate]) async throws {
        let updatedRates: [RateEntity] = existingRates.compactMap { existingRate in
            guard let newRate = actualRates.first(
                where: {
                    let isFromCodeEqual = $0.fromCurrencyCode.rawValue == existingRate.fromCurrencyCode
                    let isToCodeEqual = $0.toCurrencyCode.rawValue == existingRate.toCurrencyCode

                    return isFromCodeEqual && isToCodeEqual
                })
            else { return nil }

            return RateEntity(
                id: existingRate.id,
                fromCurrencyCode: existingRate.fromCurrencyCode,
                toCurrencyCode: existingRate.toCurrencyCode,
                value: newRate.value.toString() ?? existingRate.value,
                updatedAt: newRate.updatedAt
            )
        }

        try await databaseClient.save(updatedRates)
    }
}

// MARK: - RatesDBServiceInterface

extension RatesDBService: RatesDBServiceInterface {
    func saveRates(_ rates: [Rate], baseCurrency: String) async throws {
        let predicate: Predicate<RateEntity> = #Predicate {
            $0.fromCurrencyCode == baseCurrency
        }

        do {
            let existingRates = try await databaseClient.fetch(
                predicate: predicate,
                sortDescriptors: [],
                fetchOffset: nil,
                fetchLimit: nil
            )

            guard existingRates.isEmpty else {
                try await updateRates(existingRates: existingRates, actualRates: rates)

                return
            }

            try await databaseClient.save(rates.map { RateEntity(from: $0) })
        } catch {
            throw error
        }
    }

    func fetchRateBy(toCurrencyCode: String, fromCurrencyCode: String) async throws -> Rate? {
        let predicate: Predicate<RateEntity> = #Predicate {
            $0.fromCurrencyCode == fromCurrencyCode && $0.toCurrencyCode == toCurrencyCode
        }

        do {
            let rate: RateEntity? = try await databaseClient.fetch(
                predicate: predicate,
                sortDescriptors: [],
                fetchOffset: nil,
                fetchLimit: nil
            ).first

            guard let rate else { return nil }

            return Rate(from: rate)
        } catch {
            throw error
        }
    }
}
