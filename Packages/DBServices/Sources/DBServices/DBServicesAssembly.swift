import Database
import Entities
import SwiftData

// MARK: - DBServicesAssemblyInterface

public protocol DBServicesAssemblyInterface {
    var ratesDBService: RatesDBServiceInterface { get }
}

// MARK: - DBServicesAssembly

public final class DBServicesAssembly: DBServicesAssemblyInterface {
    // MARK: - Public Properties

    public lazy var ratesDBService: RatesDBServiceInterface = RatesDBService(
        databaseClient: databaseClient
    )

    // MARK: - Private Properties

    private lazy var container = try! ModelContainer(for: RateEntity.self)
    private lazy var databaseClient = DatabaseClient(container: container)

    // MARK: - Init

    public init() {}
}
