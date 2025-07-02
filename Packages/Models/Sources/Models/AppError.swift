import Foundation

// MARK: - AppError

public enum AppError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case transportError

    case unauthorized
    case notFound
    case forbidden
    case requestsLimit
    case validationError

    case localSaving
    case localDeleting
    case localFetching

    case unknown

    public var message: String {
        switch self {
        case .invalidURL,
             .invalidResponse,
             .noData,
             .decodingError,
             .transportError,
             .unauthorized,
             .notFound,
             .forbidden,
             .validationError,
             .unknown:
            "Error.unknown.title".localized()

        case .requestsLimit:
            "Error.requests.limit.title".localized()

        case .localSaving:
            "Error.database.saving.title".localized()

        case .localDeleting:
            "Error.database.deleting.title".localized()

        case .localFetching:
            "Error.database.fetching.title".localized()
        }
    }
}
