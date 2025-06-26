import Foundation
import Entities
import Database
import Domain

// MARK: - ExchangesDBServiceInterface

public protocol ExchangesDBServiceInterface {
    func saveExchange(_ exchange: Exchange) async throws
    func fetchExchanges(page: Int, fetchLimit: Int) async throws -> [Exchange]
    func fetchExchanges(by fromCurrencyCode: String, toCurrencyCode: String) async throws -> [Exchange]
}

// MARK: - ExchangesDBService

final class ExchangesDBService {
    // MARK: - Private Properties

    private let databaseClient: DatabaseClientInterface

    // MARK: - Init

    init(databaseClient: DatabaseClientInterface) {
        self.databaseClient = databaseClient
    }
}

// MARK: - ExchangesDBServiceInterface

extension ExchangesDBService: ExchangesDBServiceInterface {
    func saveExchange(_ exchange: Exchange) async throws {
        do {
            try await databaseClient.save(ExchangeEntity(from: exchange))
        } catch {
            throw error
        }
    }

    func fetchExchanges(page: Int, fetchLimit: Int) async throws -> [Exchange] {
        let sortDescriptor = SortDescriptor<ExchangeEntity>(\.createdAt, order: .reverse)

        do {
            let entities: [ExchangeEntity] = try await databaseClient.fetch(
                predicate: nil,
                sortDescriptors: [sortDescriptor],
                fetchOffset: page * fetchLimit,
                fetchLimit: fetchLimit
            )

            return entities.compactMap { Exchange(from: $0) }
        } catch {
            throw error
        }
    }

    func fetchExchanges(by fromCurrencyCode: String, toCurrencyCode: String) async throws -> [Exchange] {
        let sortDescriptor = SortDescriptor<ExchangeEntity>(\.createdAt, order: .reverse)
        let predicate: Predicate<ExchangeEntity> = #Predicate {
            $0.fromCurrencyCode == fromCurrencyCode && $0.toCurrencyCode == toCurrencyCode
        }

        do {
            let entities: [ExchangeEntity] = try await databaseClient.fetch(
                predicate: predicate,
                sortDescriptors: [sortDescriptor],
                fetchOffset: nil,
                fetchLimit: nil
            )

            return entities.compactMap { Exchange(from: $0) }
        } catch {
            throw error
        }
    }
}
