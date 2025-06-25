import Foundation

// MARK: - String+localized

public extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}
