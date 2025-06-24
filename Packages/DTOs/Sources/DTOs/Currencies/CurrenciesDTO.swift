import Foundation

// MARK: - CurrenciesDTO

public struct CurrenciesDTO: Codable {
    public let data: [String: CurrencyDTO]
}
