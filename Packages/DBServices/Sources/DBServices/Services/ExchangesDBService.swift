import Foundation
import Entities
import Database
import Domain

// MARK: - ExchangesDBServiceInterface

public protocol ExchangesDBServiceInterface {
    func saveExchange(_ exchange: Exchange) async throws
    func fetchExchanges() async throws -> [Exchange]
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

    func fetchExchanges() async throws -> [Exchange] {
        let sortDescriptor = SortDescriptor<ExchangeEntity>(\.createdAt, order: .reverse)

        do {
            let entities: [ExchangeEntity] = try await databaseClient.fetch(
                predicate: nil,
                sortDescriptors: [sortDescriptor]
            )

            return entities.compactMap { Exchange(from: $0) }
        } catch {
            throw error
        }
    }
}
