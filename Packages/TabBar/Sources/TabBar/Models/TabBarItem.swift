import SwiftUI
import DesignSystem
import Utilities

// MARK: - TabBarItem

enum TabBarItem: Int, Identifiable, CaseIterable {
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

    var image: Image {
        switch self {
        case .exchange:
            CCIcon.System.dollarIcon.image

        case .history:
            CCIcon.System.listIcon.image
        }
    }
}
