import Foundation
import DTOs
import Models

// MARK: - Rate+from

extension Rate {
    init?(from rate: Decimal, baseCurrency: String, resultCurrency: String) {
        guard
            let fromCurrencyCode = CurrencyCode(rawValue: baseCurrency),
            let toCurrencyCode = CurrencyCode(rawValue: resultCurrency)
        else { return nil }

        self.init(
            fromCurrencyCode: fromCurrencyCode,
            toCurrencyCode: toCurrencyCode,
            value: rate,
            updatedAt: Date()
        )
    }
}
