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
}
