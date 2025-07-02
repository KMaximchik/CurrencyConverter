import Foundation
import Network

// MARK: - APIServicesAssemblyInterface

public protocol APIServicesAssemblyInterface {
    var ratesAPIService: RatesAPIServiceInterface { get }
}

// MARK: - APIServicesAssembly

public final class APIServicesAssembly: APIServicesAssemblyInterface {
    // MARK: - Public Properties

    public lazy var ratesAPIService: RatesAPIServiceInterface = RatesAPIService(
        networkClient: networkClient
    )

    // MARK: - Private Properties

    private let networkClient: NetworkClientInterface

    // MARK: - Init

    public init(networkClient: NetworkClientInterface) {
        self.networkClient = networkClient
    }
}
