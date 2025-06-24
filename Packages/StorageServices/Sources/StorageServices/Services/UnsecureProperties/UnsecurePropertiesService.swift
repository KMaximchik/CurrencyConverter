import Foundation
import Extensions

// MARK: - UnsecurePropertiesServiceInterface

public protocol UnsecurePropertiesServiceInterface {
    subscript<Result: Codable>(key: UnsecureKeys) -> Result? { get set }
}

// MARK: - UnsecurePropertiesService

final class UnsecurePropertiesService {
    // MARK: - Private Properties

    private let userDefaults: UserDefaults

    // MARK: - Init

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

// MARK: - UnsecurePropertiesServiceInterface

extension UnsecurePropertiesService: UnsecurePropertiesServiceInterface {
    subscript<Result: Codable>(key: UnsecureKeys) -> Result? {
        get {
            var codableValue = userDefaults.value(forKey: key.rawValue) as? String

            guard let value: Result = codableValue?.parse(to: Result.self) else {
                return nil
            }

            return value
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                let codableValue = String(decoding: data, as: UTF8.self)

                userDefaults.set(codableValue, forKey: key.rawValue)
            } catch {}
        }
    }
}
