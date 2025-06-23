import DBServices
import APIServices

// MARK: - UseCasesAssemblyInterface

public protocol UseCasesAssemblyInterface {}

// MARK: - UseCasesAssembly

public final class UseCasesAssembly: UseCasesAssemblyInterface {
    // MARK: - Private Properties

    private let dbServicesAssembly: DBServicesAssemblyInterface
    private let apiServicesAssembly: APIServicesAssemblyInterface

    // MARK: - Init

    public init(
        dbServicesAssembly: DBServicesAssemblyInterface,
        apiServicesAssembly: APIServicesAssemblyInterface
    ) {
        self.dbServicesAssembly = dbServicesAssembly
        self.apiServicesAssembly = apiServicesAssembly
    }

    public convenience init() {
        self.init(
            dbServicesAssembly: DBServicesAssembly(),
            apiServicesAssembly: APIServicesAssembly()
        )
    }
}
