import SwiftUI

// MARK: - CCIconToken

public struct CCIconToken {
    public let name: String
    public let sourceType: CCIconSourceType

    public var image: Image {
        switch sourceType {
        case .system:
            Image(systemName: name)

        case .assets:
            Image(name)
        }
    }

    public var uiImage: UIImage {
        switch sourceType {
        case .system:
            UIImage(systemName: name) ?? UIImage()

        case .assets:
            UIImage(named: name) ?? UIImage()
        }
    }

    public init(name: String, sourceType: CCIconSourceType) {
        self.name = name
        self.sourceType = sourceType
    }
}
