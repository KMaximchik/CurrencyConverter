import DTOs
import Domain

// MARK: - Currency+from

extension Currency {
    init(from currencyDTO: CurrencyDTO) {
        self.init(
            symbol: currencyDTO.symbol,
            name: currencyDTO.name,
            symbolNative: currencyDTO.symbolNative,
            decimalDigits: currencyDTO.decimalDigits,
            rounding: currencyDTO.rounding,
            code: CurrencyCode(from: currencyDTO.code) ?? .USD,
            namePlural: currencyDTO.namePlural
        )
    }
}
