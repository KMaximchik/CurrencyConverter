import Core
import Network
import Database
import Utilities

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

        self = .unknown
    }

    init(from networkError: NetworkError) {
        switch networkError {
        case .invalidURL:
            self = .invalidURL

        case .invalidResponse:
            self = .invalidResponse

        case .serverError(let statusCode):
            switch statusCode {
            case 401:
                self = .unauthorized

            case 403:
                self = .forbidden

            case 404:
                self = .notFound

            case 422:
                self = .validationError

            case 429:
                self = .requestsLimit

            default:
                self = .unknown
            }

        case .noData:
            self = .noData

        case .decodingError:
            self = .decodingError

        case .transportError:
            self = .transportError
        }
    }

    init(from databaseError: DatabaseError) {
        switch databaseError {
        case .savingError:
            self = .localSaving

        case .fetchingError:
            self = .localFetching

        case .deletingError:
            self = .localDeleting
        }
    }
}
