import Foundation

// MARK: - StorageServicesAssemblyInterface

public protocol StorageServicesAssemblyInterface {
    var unsecurePropertiesService: UnsecurePropertiesServiceInterface { get }
}

// MARK: - StorageServicesAssembly

public final class StorageServicesAssembly: StorageServicesAssemblyInterface {
    // MARK: - Public Properties

    public lazy var unsecurePropertiesService: UnsecurePropertiesServiceInterface = UnsecurePropertiesService(
        userDefaults: userDefaults
    )

    // MARK: - Private Properties

    private let userDefaults: UserDefaults

    // MARK: - Init

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}
