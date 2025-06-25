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

    private let networkClient: NetworkClientInterface = NetworkClient(session: URLSession.shared)

    // MARK: - Init

    public init() {}
}
