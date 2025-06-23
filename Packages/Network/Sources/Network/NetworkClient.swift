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
            let apiError = try? JSONDecoder().decode(APIError.self, from: data)

            throw NetworkError.serverError(
                statusCode: statusCode,
                apiError: apiError
            )
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
