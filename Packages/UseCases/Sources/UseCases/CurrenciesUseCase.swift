import Foundation
import Domain
import APIServices
import DBServices
import StorageServices
import Core

// MARK: - CurrenciesUseCaseInterface

public protocol CurrenciesUseCaseInterface {
    func getRate(baseCurrency: CurrencyCode, toCurrency: CurrencyCode) async -> Result<Rate?, AppError>
    func calculate(value: Decimal, rate: Rate) -> Decimal
    func getSavedCurrencyPair() -> (fromCurrencyCode: String, toCurrencyCode: String)?
    func saveCurrencyPair(fromCurrencyCode: String, toCurrencyCode: String)
}

// MARK: - CurrenciesUseCase

final class CurrenciesUseCase {
    // MARK: - Private Properties

    private let ratesAPIService: RatesAPIServiceInterface
    private let ratesDBService: RatesDBServiceInterface
    private var unsecurePropertiesService: UnsecurePropertiesServiceInterface

    // MARK: - Init

    init(
        ratesAPIService: RatesAPIServiceInterface,
        ratesDBService: RatesDBServiceInterface,
        unsecurePropertiesService: UnsecurePropertiesServiceInterface
    ) {
        self.ratesAPIService = ratesAPIService
        self.ratesDBService = ratesDBService
        self.unsecurePropertiesService = unsecurePropertiesService
    }

    // MARK: - Private Methods

    private func saveRates(_ rates: [Rate], baseCurrency: CurrencyCode) async throws {
        do {
            try await ratesDBService.saveRates(rates, baseCurrency: baseCurrency.rawValue)
        } catch {
            throw error
        }
    }

    private func needsRefresh(_ rate: Rate) -> Bool {
        Date().timeIntervalSince(rate.updatedAt) > 60 * 10
    }
}

// MARK: - CurrenciesUseCaseInterface

extension CurrenciesUseCase: CurrenciesUseCaseInterface {
    func getRate(baseCurrency: CurrencyCode, toCurrency: CurrencyCode) async -> Result<Rate?, AppError> {
        do {
            let cachedRate = try? await ratesDBService.fetchRateBy(
                toCurrencyCode: toCurrency.rawValue,
                fromCurrencyCode: baseCurrency.rawValue
            )

            if let cachedRate, !needsRefresh(cachedRate) {
                return .success(cachedRate)
            }

            let actualRates = try await ratesAPIService.getRates(
                baseCurrency: baseCurrency.rawValue,
                currencies: CurrencyCode.allCases.map { $0.rawValue }.joined(separator: ",")
            )

            try await saveRates(actualRates, baseCurrency: baseCurrency)

            let rate = actualRates.first { $0.fromCurrencyCode == baseCurrency && $0.toCurrencyCode == toCurrency }

            return .success(rate)
        } catch {
            let cachedRate = try? await ratesDBService.fetchRateBy(
                toCurrencyCode: toCurrency.rawValue,
                fromCurrencyCode: baseCurrency.rawValue
            )

            if let cachedRate {
                return .success(cachedRate)
            }

            return .failure(AppError(from: error))
        }
    }

    func calculate(value: Decimal, rate: Rate) -> Decimal {
        rate.value * value
    }

    func getSavedCurrencyPair() -> (fromCurrencyCode: String, toCurrencyCode: String)? {
        guard
            let fromCurrencyCode: String = unsecurePropertiesService[.fromCurrencyCode],
            let toCurrencyCode: String = unsecurePropertiesService[.toCurrencyCode]
        else { return nil }

        return (fromCurrencyCode, toCurrencyCode)
    }

    func saveCurrencyPair(fromCurrencyCode: String, toCurrencyCode: String) {
        unsecurePropertiesService[.fromCurrencyCode] = fromCurrencyCode
        unsecurePropertiesService[.toCurrencyCode] = toCurrencyCode
    }
}
