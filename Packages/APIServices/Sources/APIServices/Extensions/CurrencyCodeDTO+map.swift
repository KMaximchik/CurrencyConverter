import DTOs
import Domain

// MARK: - CurrencyCodeDTO+map

extension CurrencyCodeDTO {
    func mapToCurrencyName() -> CurrencyCode {
        CurrencyCode(rawValue: rawValue) ?? .USD
    }
}
