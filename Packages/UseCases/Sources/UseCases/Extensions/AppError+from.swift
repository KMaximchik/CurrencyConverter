import Core
import Network
import Database
import Extensions

// MARK: - AppError+from

public extension AppError {
    init(from error: Error) {
        if let networkError = error as? NetworkError {
            self.init(from: networkError)
            return
        }

        if let databaseError = error as? DatabaseError {
            self.init(from: databaseError)
            return
        }

        self = .unknown(message: "Error.unknown.title".localized())
    }

    init(from networkError: NetworkError) {
        switch networkError {
        case .invalidURL, .invalidResponse, .transportError, .noData, .decodingError, .serverError, .unauthorized, .notFound, .forbidden, .validationError:
            self = .network(message: "Error.unknown.title".localized())

        case .requestsLimit:
            self = .network(message: "Error.requests.limit.title".localized())
        }
    }

    init(from databaseError: DatabaseError) {
        switch databaseError {
        case .savingError, .deletingError, .fetchingError:
            self = .database(message: "Error.unknown.title".localized())
        }
    }
}
