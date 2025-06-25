import Foundation

// MARK: - String+toDecimal

public extension String {
    func toDecimal(
        locale: Locale = .current,
        minimumFractionDigits: Int = .zero,
        maximumFractionDigits: Int = 2
    ) -> Decimal? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits

        return formatter.number(from: self)?.decimalValue
    }
}
