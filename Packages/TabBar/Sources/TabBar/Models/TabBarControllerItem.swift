import UIKit

// MARK: - TabBarControllerItem

struct TabBarControllerItem {
    let itemDescriptor: TabBarItemDescriptor
    let controller: UIViewController

    init(
        itemDescriptor: TabBarItemDescriptor,
        controller: UIViewController
    ) {
        self.itemDescriptor = itemDescriptor
        self.controller = controller
    }
}
