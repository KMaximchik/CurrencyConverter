import Foundation

// MARK: - Exchange

public struct Exchange {
    public let id: UUID
    public let fromCurrencyCode: String
    public let toCurrencyCode: String
    public let value: Decimal
    public let initialValue: Decimal
    public let rateValue: Decimal
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        fromCurrencyCode: String,
        toCurrencyCode: String,
        value: Decimal,
        initialValue: Decimal,
        rateValue: Decimal,
        createdAt: Date
    ) {
        self.id = id
        self.fromCurrencyCode = fromCurrencyCode
        self.toCurrencyCode = toCurrencyCode
        self.value = value
        self.initialValue = initialValue
        self.rateValue = rateValue
        self.createdAt = createdAt
    }
}
