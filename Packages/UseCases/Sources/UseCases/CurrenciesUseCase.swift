import Domain
import APIServices
import StorageServices

// MARK: - CurrenciesUseCaseInterface

public protocol CurrenciesUseCaseInterface {
    func getCurrencies(currencies: [CurrencyCode]) async throws -> [Currency]
    func getRates(baseCurrency: CurrencyCode, currencies: [CurrencyCode]) async throws -> [Rate]
}

// MARK: - CurrenciesUseCase

final class CurrenciesUseCase {
    // MARK: - Private Properties

    private let currenciesAPIService: CurrenciesAPIServiceInterface
    private let ratesAPIService: RatesAPIServiceInterface
    private let unsecurePropertiesService: UnsecurePropertiesServiceInterface

    // MARK: - Init

    init(
        currenciesAPIService: CurrenciesAPIServiceInterface,
        ratesAPIService: RatesAPIServiceInterface,
        unsecurePropertiesService: UnsecurePropertiesServiceInterface
    ) {
        self.currenciesAPIService = currenciesAPIService
        self.ratesAPIService = ratesAPIService
        self.unsecurePropertiesService = unsecurePropertiesService
    }
}

// MARK: - CurrenciesUseCaseInterface

extension CurrenciesUseCase: CurrenciesUseCaseInterface {
    func getCurrencies(currencies: [CurrencyCode]) async throws -> [Currency] {
        do {
            return try await currenciesAPIService.getCurrencies(
                currencies: currencies.map { $0.rawValue }.joined(separator: ",")
            )
        } catch {
            throw error
        }
    }

    func getRates(baseCurrency: CurrencyCode, currencies: [CurrencyCode]) async throws -> [Rate] {
        do {
            return try await ratesAPIService.getRates(
                baseCurrency: baseCurrency.rawValue,
                currencies: currencies.map { $0.rawValue }.joined(separator: ",")
            )
        } catch {
            throw error
        }
    }
}
