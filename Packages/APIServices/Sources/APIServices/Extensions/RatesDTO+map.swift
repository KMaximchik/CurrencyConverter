import Foundation
import DTOs
import Domain

// MARK: - RatesDTO+map

extension RatesDTO {
    func mapToRates(baseCurrency: String) -> [Rate] {
        data.compactMap {
            guard
                let fromCurrencyCode = CurrencyCode(rawValue: baseCurrency),
                let toCurrencyCode = CurrencyCode(rawValue: $0.key)
            else { return nil }

            return Rate(
                fromCurrencyCode: fromCurrencyCode,
                toCurrencyCode: toCurrencyCode,
                value: $0.value,
                updatedAt: Date()
            )
        }
    }
}
