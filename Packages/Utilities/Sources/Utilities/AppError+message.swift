import Core

// MARK: - AppError+message

public extension AppError {
    var message: String {
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
