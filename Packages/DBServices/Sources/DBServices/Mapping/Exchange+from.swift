import Domain
import Entities
import Foundation
import Extensions

// MARK: - Exchange+from

public extension Exchange {
    init?(from exchangeEntity: ExchangeEntity) {
        guard
            let value = exchangeEntity.value.toDecimal(),
            let rateValue = exchangeEntity.rateValue.toDecimal(),
            let initialValue = exchangeEntity.initialValue.toDecimal()
        else { return nil }

        self.init(
            id: exchangeEntity.id,
            fromCurrencyCode: exchangeEntity.fromCurrencyCode,
            toCurrencyCode: exchangeEntity.toCurrencyCode,
            value: value,
            initialValue: initialValue,
            rateValue: rateValue,
            createdAt: exchangeEntity.createdAt
        )
    }
}
