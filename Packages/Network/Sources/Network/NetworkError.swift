import Foundation

// MARK: - NetworkError

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
    case transportError(Error)
}
