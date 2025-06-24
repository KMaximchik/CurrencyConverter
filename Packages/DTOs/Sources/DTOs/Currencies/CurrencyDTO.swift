import Foundation

// MARK: - CurrencyDTO

public struct CurrencyDTO: Codable {
    public let symbol: String
    public let name: String
    public let symbolNative: String
    public let decimalDigits: Int
    public let rounding: Int
    public let code: CurrencyCodeDTO
    public let namePlural: String

    public enum CodingKeys: String, CodingKey {
        case symbol
        case name
        case symbolNative = "symbol_native"
        case decimalDigits = "decimal_digits"
        case rounding
        case code
        case namePlural = "name_plural"
    }
}
