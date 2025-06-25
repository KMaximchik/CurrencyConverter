import DBServices
import APIServices
import StorageServices

// MARK: - UseCasesAssemblyInterface

public protocol UseCasesAssemblyInterface {
    var currenciesUseCase: CurrenciesUseCaseInterface { get }
    var historyUseCase: HistoryUseCaseInterface { get }
}

// MARK: - UseCasesAssembly

public final class UseCasesAssembly: UseCasesAssemblyInterface {
    // MARK: - Public Properties

    public lazy var currenciesUseCase: CurrenciesUseCaseInterface = CurrenciesUseCase(
        currenciesAPIService: apiServicesAssembly.currenciesAPIService,
        ratesAPIService: apiServicesAssembly.ratesAPIService,
        ratesDBService: dbServicesAssembly.ratesDBService,
        unsecurePropertiesService: storageServicesAssembly.unsecurePropertiesService
    )

    public lazy var historyUseCase: HistoryUseCaseInterface = HistoryUseCase(
        exchangesDBService: dbServicesAssembly.exchangesDBService
    )

    // MARK: - Private Properties

    private let dbServicesAssembly: DBServicesAssemblyInterface
    private let apiServicesAssembly: APIServicesAssemblyInterface
    private let storageServicesAssembly: StorageServicesAssemblyInterface

    // MARK: - Init

    public init(
        dbServicesAssembly: DBServicesAssemblyInterface,
        apiServicesAssembly: APIServicesAssemblyInterface,
        storageServicesAssembly: StorageServicesAssemblyInterface
    ) {
        self.dbServicesAssembly = dbServicesAssembly
        self.apiServicesAssembly = apiServicesAssembly
        self.storageServicesAssembly = storageServicesAssembly
    }

    public convenience init() {
        self.init(
            dbServicesAssembly: DBServicesAssembly(),
            apiServicesAssembly: APIServicesAssembly(),
            storageServicesAssembly: StorageServicesAssembly()
        )
    }
}
