import Foundation
import Domain
import APIServices
import DBServices
import StorageServices
import Core

// MARK: - CurrenciesUseCaseInterface

public protocol CurrenciesUseCaseInterface {
    func getCurrencies(currencies: [CurrencyCode]) async -> Result<[Currency], AppError>
    func getRate(baseCurrency: CurrencyCode, toCurrency: CurrencyCode) async -> Result<Rate?, AppError>
    func calculate(value: Decimal, rate: Rate) -> Decimal
    func getSavedCurrencyPair() -> (fromCurrencyCode: String, toCurrencyCode: String)?
    func saveCurrencyPair(fromCurrencyCode: String, toCurrencyCode: String)
}

// MARK: - CurrenciesUseCase

final class CurrenciesUseCase {
    // MARK: - Private Properties

    private let currenciesAPIService: CurrenciesAPIServiceInterface
    private let ratesAPIService: RatesAPIServiceInterface
    private let ratesDBService: RatesDBServiceInterface
    private var unsecurePropertiesService: UnsecurePropertiesServiceInterface

    // MARK: - Init

    init(
        currenciesAPIService: CurrenciesAPIServiceInterface,
        ratesAPIService: RatesAPIServiceInterface,
        ratesDBService: RatesDBServiceInterface,
        unsecurePropertiesService: UnsecurePropertiesServiceInterface
    ) {
        self.currenciesAPIService = currenciesAPIService
        self.ratesAPIService = ratesAPIService
        self.ratesDBService = ratesDBService
        self.unsecurePropertiesService = unsecurePropertiesService
    }

    // MARK: - Private Methods

    private func saveRates(_ rates: [Rate]) async throws {
        do {
            try await ratesDBService.saveRates(rates)
        } catch {
            throw error
        }
    }
}

// MARK: - CurrenciesUseCaseInterface

extension CurrenciesUseCase: CurrenciesUseCaseInterface {
    func getCurrencies(currencies: [CurrencyCode]) async -> Result<[Currency], AppError> {
        do {
            let currencies = try await currenciesAPIService.getCurrencies(
                currencies: currencies.map { $0.rawValue }.joined(separator: ",")
            )

            return .success(currencies)
        } catch {
            return .failure(AppError(from: error))
        }
    }

    func getRate(baseCurrency: CurrencyCode, toCurrency: CurrencyCode) async -> Result<Rate?, AppError> {
        do {
            let rates = try await ratesAPIService.getRates(
                baseCurrency: baseCurrency.rawValue,
                currencies: CurrencyCode.allCases.map { $0.rawValue }.joined(separator: ",")
            )

            try await saveRates(rates)

            let rate = rates.first { $0.fromCurrencyCode == baseCurrency && $0.toCurrencyCode == toCurrency }

            return .success(rate)
        } catch {
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
