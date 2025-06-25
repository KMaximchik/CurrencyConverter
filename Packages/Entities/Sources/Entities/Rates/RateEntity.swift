import SwiftData
import Foundation

// MARK: - RateEntity

@Model
public final class RateEntity {
    @Attribute(.unique)
    public var id: UUID

    public var fromCurrencyCode: String
    public var toCurrencyCode: String
    public var value: String
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        fromCurrencyCode: String,
        toCurrencyCode: String,
        value: String,
        updatedAt: Date
    ) {
        self.id = id
        self.fromCurrencyCode = fromCurrencyCode
        self.toCurrencyCode = toCurrencyCode
        self.value = value
        self.updatedAt = updatedAt
    }
}
