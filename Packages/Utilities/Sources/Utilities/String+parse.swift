import Foundation

// MARK: - String+parse

extension String {
    public func parse<T>(to type: T.Type) -> T? where T: Decodable {
        guard let data = data(using: .utf8) else { return nil }

        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            return nil
        }
    }
}
