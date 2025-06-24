import Foundation

// MARK: - Rate

public struct Rate {
    public let fromCurrencyCode: CurrencyCode
    public let toCurrencyCode: CurrencyCode
    public let value: Decimal

    public init(
        fromCurrencyCode: CurrencyCode,
        toCurrencyCode: CurrencyCode,
        value: Decimal
    ) {
        self.fromCurrencyCode = fromCurrencyCode
        self.toCurrencyCode = toCurrencyCode
        self.value = value
    }
}
