import Foundation
import Entities
import Domain

// MARK: - RateEntity+from

public extension RateEntity {
    convenience init(rate: Rate) {
        self.init(
            fromCurrencyCode: rate.fromCurrencyCode.rawValue,
            toCurrencyCode: rate.toCurrencyCode.rawValue,
            value: NSDecimalNumber(decimal: rate.value).stringValue,
            updatedAt: rate.updatedAt
        )
    }
}
