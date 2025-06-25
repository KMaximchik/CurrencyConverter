import Foundation
import Entities
import Domain
import Utilities

// MARK: - RateEntity+from

public extension RateEntity {
    convenience init(from rate: Rate) {
        self.init(
            fromCurrencyCode: rate.fromCurrencyCode.rawValue,
            toCurrencyCode: rate.toCurrencyCode.rawValue,
            value: rate.value.toString() ?? "",
            updatedAt: rate.updatedAt
        )
    }
}
