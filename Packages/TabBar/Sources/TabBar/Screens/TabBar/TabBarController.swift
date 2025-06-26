import UIKit
import DesignSystem

// MARK: - TabBarController

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    // MARK: - Internal Properties

    var customTabs = [TabBarControllerItem]() {
        didSet {
            viewControllers = customTabs.map { $0.controller }
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.backButtonTitle = ""
    }

    // MARK: - Internal Methods

    func switchTab(to tab: TabBarItemDescriptor) {
        guard
            let index = customTabs.firstIndex(where: { tab.id == $0.itemDescriptor.id })
        else { return }

        self.selectedIndex = index
    }

    // MARK: - Private Methods

    private func setupUI() {
        view.backgroundColor = CCColor.backgroundPrimary.uiColor
        //
        //        tabBar.backgroundColor = CCColor.backgroundSecondary.uiColor
        //        tabBar.tintColor = CCColor.accentBlue.uiColor
        //        tabBar.unselectedItemTintColor = CCColor.labelSecondary.uiColor
        //        tabBar.isTranslucent = false

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = CCColor.backgroundSecondary.uiColor
        appearance.stackedLayoutAppearance.normal.iconColor = CCColor.labelSecondary.uiColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: CCColor.labelSecondary.uiColor
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = CCColor.accentBlue.uiColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: CCColor.accentBlue.uiColor
        ]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
