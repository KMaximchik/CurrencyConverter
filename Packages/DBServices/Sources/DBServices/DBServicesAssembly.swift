import Database
import Entities
import SwiftData

// MARK: - DBServicesAssemblyInterface

public protocol DBServicesAssemblyInterface {
    var ratesDBService: RatesDBServiceInterface { get }
    var exchangesDBService: ExchangesDBServiceInterface { get }
}

// MARK: - DBServicesAssembly

public final class DBServicesAssembly: DBServicesAssemblyInterface {
    // MARK: - Public Properties

    public lazy var ratesDBService: RatesDBServiceInterface = RatesDBService(
        databaseClient: databaseClient
    )

    public lazy var exchangesDBService: ExchangesDBServiceInterface = ExchangesDBService(
        databaseClient: databaseClient
    )

    // MARK: - Private Properties

    private lazy var container = try! ModelContainer(for: RateEntity.self, ExchangeEntity.self)
    private lazy var databaseClient = DatabaseClient(container: container)

    // MARK: - Init

    public init() {}
}
