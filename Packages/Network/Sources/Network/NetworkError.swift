import Foundation

// MARK: - NetworkError

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case transportError(Error)
    case serverError(statusCode: Int, apiError: APIError?)
    case noData
    case decodingError(Error)
}
