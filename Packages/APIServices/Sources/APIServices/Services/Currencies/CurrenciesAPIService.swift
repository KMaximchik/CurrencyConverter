import Network
import DTOs
import Domain

// MARK: - CurrenciesAPIServiceInterface

public protocol CurrenciesAPIServiceInterface {
    func getCurrencies(currencies: String) async throws -> [Currency]
}

// MARK: - CurrenciesAPIService

final class CurrenciesAPIService {
    // MARK: - Private Properties

    private let networkClient: NetworkClientInterface

    // MARK: - Init

    init(networkClient: NetworkClientInterface) {
        self.networkClient = networkClient
    }
}

// MARK: - CurrenciesAPIServiceInterface

extension CurrenciesAPIService: CurrenciesAPIServiceInterface {
    func getCurrencies(currencies: String) async throws -> [Currency] {
        do {
            let currencies: CurrenciesDTO = try await networkClient.request(
                to: CurrenciesEndpoint.getCurrencies(
                    currencies: currencies
                )
            )

            return currencies.data.values.map { Currency(from: $0) }
        } catch {
            throw error
        }
    }
}
