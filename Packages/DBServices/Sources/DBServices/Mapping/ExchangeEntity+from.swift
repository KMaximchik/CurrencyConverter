import Foundation
import Entities
import Models
import Utilities

// MARK: - ExchangeEntity+from

public extension ExchangeEntity {
    convenience init(from exchange: Exchange) {
        self.init(
            id: exchange.id,
            fromCurrencyCode: exchange.fromCurrencyCode,
            toCurrencyCode: exchange.toCurrencyCode,
            value: exchange.valueString ?? "",
            initialValue: exchange.initialValueString ?? "",
            rateValue: exchange.rateValueString ?? "",
            createdAt: exchange.createdAt
        )
    }
}
