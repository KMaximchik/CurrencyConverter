import Foundation

// MARK: - Decimal+toString

public extension Decimal {
    func toString(
        locale: Locale = .current,
        minimumFractionDigits: Int = .zero,
        maximumFractionDigits: Int = 2
    ) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits

        return formatter.string(from: NSDecimalNumber(decimal: self))
    }
}
