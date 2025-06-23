import UIKit

// MARK: - TabBarItemDescriptor

protocol TabBarItemDescriptor {
    var id: String { get }
    var displayTitle: String { get }
    var image: UIImage? { get }
    var selectedImage: UIImage? { get }
}

extension TabBarItemDescriptor {
    var tabBarItem: UITabBarItem {
        UITabBarItem(title: displayTitle, image: image, selectedImage: selectedImage)
    }
}
