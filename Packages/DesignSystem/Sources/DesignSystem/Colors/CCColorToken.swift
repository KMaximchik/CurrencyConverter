import SwiftUI

// MARK: - CCColorToken

public struct CCColorToken {
    public let name: String

    public var color: Color {
        Color(name, bundle: .module)
    }

    public var uiColor: UIColor {
        UIColor(named: name, in: .module, compatibleWith: nil) ?? .white
    }

    public init(name: String) {
        self.name = name
    }
}
