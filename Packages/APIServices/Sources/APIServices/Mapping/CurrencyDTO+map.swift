import DTOs
import Domain

// MARK: - CurrencyDTO+map

extension CurrencyDTO {
    func mapToCurrency() -> Currency {
        Currency(
            symbol: symbol,
            name: name,
            symbolNative: symbolNative,
            decimalDigits: decimalDigits,
            rounding: rounding,
            code: code.mapToCurrencyName(),
            namePlural: namePlural
        )
    }
}
