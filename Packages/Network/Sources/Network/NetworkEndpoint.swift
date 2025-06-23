import Foundation

// MARK: - NetworkEndpoint

public protocol NetworkEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: NetworkMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}
