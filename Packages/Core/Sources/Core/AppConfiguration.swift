import Foundation

// MARK: - AppConfiguration

public final class AppConfiguration {
    // MARK: - Nested Types

    enum PlistKeys: String {
        case apiKey = "APIKey"
    }

    // MARK: - Public Properties

    public var apiKey: String {
        Bundle.main.infoDictionary?[PlistKeys.apiKey.rawValue] as? String ?? ""
    }

    // MARK: - Static Properties

    public static let shared = AppConfiguration()
}
