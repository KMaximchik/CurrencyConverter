import Foundation
import Utilities

// MARK: - Exchange

public struct Exchange {
    public let id: UUID
    public let fromCurrencyCode: String
    public let toCurrencyCode: String
    public let value: Decimal
    public let valueString: String?
    public let initialValue: Decimal
    public let initialValueString: String?
    public let rateValue: Decimal
    public let rateValueString: String?
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
        self.valueString = value.toString()
        self.initialValue = initialValue
        self.initialValueString = initialValue.toString()
        self.rateValue = rateValue
        self.rateValueString = rateValue.toString()
        self.createdAt = createdAt
    }
}
