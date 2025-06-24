import Foundation

// MARK: - NetworkError

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case notFound
    case forbidden
    case requestsLimit
    case validationError
    case serverError(statusCode: Int, apiError: APIError?)
    case noData
    case decodingError(Error)
    case transportError(Error)
}
