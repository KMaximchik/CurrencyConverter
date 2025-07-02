import Foundation
import Models
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

        fetchInitialRates()
    }

    // MARK: - Private Methods

    private func fetchInitialRates() {
        Task {
            let codes = CurrencyCode.allCases

            await withTaskGroup(of: Void.self) { group in
                codes.forEach { code in
                    group.addTask {
                        guard
                            let rates = try? await self.ratesAPIService.getRates(
                                baseCurrency: code.rawValue,
                                currencies: codes.map { $0.rawValue }.joined(separator: ",")
                            )
                        else { return }

                        try? await self.saveRates(rates, baseCurrency: code)
                    }
                }
            }
        }
    }

    private func saveRates(_ rates: [Rate], baseCurrency: CurrencyCode) async throws {
        do {
            try await ratesDBService.saveRates(rates, baseCurrency: baseCurrency.rawValue)
        } catch {
            throw error
        }
    }

    private func getCachedRate(fromCurrencyCode: CurrencyCode, toCurrencyCode: CurrencyCode) async -> Rate? {
        try? await ratesDBService.fetchRateBy(
            toCurrencyCode: toCurrencyCode.rawValue,
            fromCurrencyCode: fromCurrencyCode.rawValue
        )
    }

    private func needsRefresh(_ rate: Rate) -> Bool {
        Date().timeIntervalSince(rate.updatedAt) > 60 * 10
    }
}

// MARK: - CurrenciesUseCaseInterface

extension CurrenciesUseCase: CurrenciesUseCaseInterface {
    func getRate(baseCurrency: CurrencyCode, toCurrency: CurrencyCode) async -> Result<Rate?, AppError> {
        do {
            let cachedRate = await getCachedRate(fromCurrencyCode: baseCurrency, toCurrencyCode: toCurrency)

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
            let cachedRate = await getCachedRate(fromCurrencyCode: baseCurrency, toCurrencyCode: toCurrency)

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
