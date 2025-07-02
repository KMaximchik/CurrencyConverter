import Foundation

// MARK: - AppConfiguration

final class AppConfiguration {
    // MARK: - Nested Types

    enum PlistKeys: String {
        case apiKey = "APIKey"
    }

    // MARK: - Internal Properties

    var apiKey: String {
        Bundle.main.infoDictionary?[PlistKeys.apiKey.rawValue] as? String ?? ""
    }

    // MARK: - Static Properties

    static let shared = AppConfiguration()
}
