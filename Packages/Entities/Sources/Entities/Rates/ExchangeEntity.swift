import SwiftData
import Foundation

// MARK: - ExchangeEntity

@Model
public final class ExchangeEntity {
    @Attribute(.unique)
    public var id: UUID

    public var fromCurrencyCode: String
    public var toCurrencyCode: String
    public var value: String
    public var initialValue: String
    public var rateValue: String
    public var createdAt: Date

    public init(
        id: UUID = UUID(),
        fromCurrencyCode: String,
        toCurrencyCode: String,
        value: String,
        initialValue: String,
        rateValue: String,
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
