import Entities
import Database
import Domain

// MARK: - RatesDBServiceInterface

public protocol RatesDBServiceInterface {
    func saveRates(_ rates: [Rate]) async throws
}

// MARK: - RatesDBService

final class RatesDBService {
    // MARK: - Private Properties

    private let databaseClient: DatabaseClientInterface

    // MARK: - Init

    init(databaseClient: DatabaseClientInterface) {
        self.databaseClient = databaseClient
    }
}

// MARK: - RatesDBServiceInterface

extension RatesDBService: RatesDBServiceInterface {
    func saveRates(_ rates: [Rate]) async throws {
        do {
            try await databaseClient.save(rates.map { RateEntity(rate: $0) })
        } catch {
            throw error
        }
    }
}
