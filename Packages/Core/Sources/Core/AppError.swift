import Foundation

// MARK: - AppError

public enum AppError: Error {
    case network(message: String)
    case database(message: String)
    case unknown(message: String)

    public var message: String {
        switch self {
        case let .network(message), let .database(message), let .unknown(message):
            message
        }
    }
}
