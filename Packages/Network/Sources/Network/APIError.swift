// MARK: - APIError

public struct APIError: Decodable {
    public let message: String?

    public init(message: String?) {
        self.message = message
    }
}
