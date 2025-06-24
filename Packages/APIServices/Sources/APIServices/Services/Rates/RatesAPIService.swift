import Network
import DTOs
import Domain

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

            return rates.mapToRates(baseCurrency: baseCurrency)
        } catch {
            throw error
        }
    }
}
