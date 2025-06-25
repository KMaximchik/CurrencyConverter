import Foundation

// MARK: - Date+format

public extension Date {
    enum FormatType {
        case ddMMyyyHHmm

        var dateFormat: String {
            switch self {
            case .ddMMyyyHHmm:
                "HH:mm:ss | dd.MM.yyyy"
            }
        }
    }

    func format(
        formatType: FormatType,
        locale: Locale = .current,
        timeZone: TimeZone = .current
    ) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = formatType.dateFormat

        return formatter.string(from: self)
    }
}
