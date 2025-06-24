import Foundation

// MARK: - NetworkClientInterface

public protocol NetworkClientInterface {
    func request<T: Decodable>(to endpoint: NetworkEndpoint) async throws -> T
}

// MARK: - NetworkClient

public class NetworkClient {
    // MARK: - Private Properties

    private let session: URLSession

    // MARK: - Init

    public init(session: URLSession) {
        self.session = session
    }

    // MARK: - Private Methods

    private func makeRequest(for endpoint: NetworkEndpoint) throws -> URLRequest {
        var url = endpoint.baseURL.appendingPathComponent(endpoint.path)

        if endpoint.method == .get, let parameters = endpoint.parameters {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)

            urlComponents?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }

            if let newURL = urlComponents?.url {
                url = newURL
            }
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if endpoint.method != .get, let parameters = endpoint.parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }

        return request
    }

    private func getProcessedError(from statusCode: Int, data: Data) -> NetworkError {
        switch statusCode {
        case 401:
            return .unauthorized

        case 403:
            return .forbidden

        case 404:
            return .notFound

        case 422:
            return .validationError

        case 429:
            return .requestsLimit

        default:
            return NetworkError.serverError(
                statusCode: statusCode,
                apiError: try? JSONDecoder().decode(APIError.self, from: data)
            )
        }
    }
}

// MARK: - NetworkClientInterface

extension NetworkClient: NetworkClientInterface {
    public func request<T: Decodable>(to endpoint: NetworkEndpoint) async throws -> T {
        let request: URLRequest

        do {
            request = try makeRequest(for: endpoint)
        } catch {
            throw NetworkError.invalidURL
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.transportError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        let statusCode = httpResponse.statusCode

        guard (200..<300).contains(statusCode) else {
            throw getProcessedError(from: statusCode, data: data)
        }

        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
