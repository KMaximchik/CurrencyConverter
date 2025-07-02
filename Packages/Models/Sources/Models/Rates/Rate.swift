import Foundation

// MARK: - Rate

public struct Rate {
    public let fromCurrencyCode: CurrencyCode
    public let toCurrencyCode: CurrencyCode
    public let value: Decimal
    public let updatedAt: Date

    public init(
        fromCurrencyCode: CurrencyCode,
        toCurrencyCode: CurrencyCode,
        value: Decimal,
        updatedAt: Date
    ) {
        self.fromCurrencyCode = fromCurrencyCode
        self.toCurrencyCode = toCurrencyCode
        self.value = value
        self.updatedAt = updatedAt
    }
}
