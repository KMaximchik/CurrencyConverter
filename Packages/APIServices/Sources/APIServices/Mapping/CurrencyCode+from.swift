import DTOs
import Domain

// MARK: - CurrencyCode+from

extension CurrencyCode {
    init?(from currencyCodeDTO: CurrencyCodeDTO) {
        self.init(rawValue: currencyCodeDTO.rawValue)
    }
}
