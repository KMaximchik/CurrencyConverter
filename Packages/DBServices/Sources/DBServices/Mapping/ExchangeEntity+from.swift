import Foundation
import Entities
import Domain
import Utilities

// MARK: - ExchangeEntity+from

public extension ExchangeEntity {
    convenience init(from exchange: Exchange) {
        self.init(
            id: exchange.id,
            fromCurrencyCode: exchange.fromCurrencyCode,
            toCurrencyCode: exchange.toCurrencyCode,
            value: exchange.value.toString() ?? "",
            initialValue: exchange.initialValue.toString() ?? "",
            rateValue: exchange.rateValue.toString() ?? "",
            createdAt: exchange.createdAt
        )
    }
}
