import Network
import DTOs
import Models

// MARK: - RatesAPIServiceInterface

public protocol RatesAPIServiceInterface {
    func getRates(baseCurrency: String, currencies: String) async throws -> [Rate]
}

// MARK: - RatesAPIService

final class RatesAPIService {
    // MARK: - Private Properties

    private let networkClient: NetworkClientInterface

    // MARK: - Init

    init(networkClient: NetworkClientInterface) {
        self.networkClient = networkClient
    }
}

// MARK: - RatesAPIServiceInterface

extension RatesAPIService: RatesAPIServiceInterface {
    func getRates(baseCurrency: String, currencies: String) async throws -> [Rate] {
        do {
            let rates: RatesDTO = try await networkClient.request(
                to: RatesEndpoint.getRates(
                    baseCurrency: baseCurrency,
                    currencies: currencies
                )
            )

            return rates.data.compactMap {
                Rate(from: $0.value, baseCurrency: baseCurrency, resultCurrency: $0.key)
            }
        } catch {
            throw error
        }
    }
}
