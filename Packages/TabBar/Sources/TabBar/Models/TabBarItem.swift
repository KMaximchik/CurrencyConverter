import UIKit
import DesignSystem
import Utilities

// MARK: - TabBarItem

enum TabBarItem: Int, CaseIterable, TabBarItemDescriptor {
    case exchange, history

    var id: String {
        rawValue.description
    }

    var displayTitle: String {
        switch self {
        case .exchange:
            "TabBar.tab.exchange.title".localized()

        case .history:
            "TabBar.tab.history.title".localized()
        }
    }

    var image: UIImage? {
        switch self {
        case .exchange:
            CCIcon.System.dollarIcon.uiImage
                .withTintColor(CCColor.labelSecondary.uiColor, renderingMode: .alwaysOriginal)

        case .history:
            CCIcon.System.listIcon.uiImage
                .withTintColor(CCColor.labelSecondary.uiColor, renderingMode: .alwaysOriginal)
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .exchange:
            CCIcon.System.dollarIcon.uiImage
                .withTintColor(CCColor.accentBlue.uiColor, renderingMode: .alwaysOriginal)

        case .history:
            CCIcon.System.listIcon.uiImage
                .withTintColor(CCColor.accentBlue.uiColor, renderingMode: .alwaysOriginal)
        }
    }
}
