import Domain
import Entities

// MARK: - Rate+from

public extension Rate {
    init?(from rateEntity: RateEntity) {
        guard
            let fromCurrencyCode = CurrencyCode(rawValue: rateEntity.fromCurrencyCode),
            let toCurrencyCode = CurrencyCode(rawValue: rateEntity.toCurrencyCode),
            let value = rateEntity.value.toDecimal()
        else { return nil }

        self.init(
            fromCurrencyCode: fromCurrencyCode,
            toCurrencyCode: toCurrencyCode,
            value: value,
            updatedAt: rateEntity.updatedAt
        )
    }
}
