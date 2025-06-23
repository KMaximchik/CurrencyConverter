import Core
import UIKit

// MARK: - TabBarCoordinatorInterface

protocol TabBarCoordinatorInterface: BaseCoordinatorInterface {}

// MARK: - TabBarCoordinator

final class TabBarCoordinator: BaseCoordinator {
    // MARK: - Private Properties

    private weak var assembly: TabBarAssemblyInterface?

    private var tabBarController: TabBarController?

    // MARK: - Init

    init(assembly: TabBarAssemblyInterface, navigationController: UINavigationController?) {
        self.assembly = assembly

        super.init(navigationController: navigationController)
    }

    // MARK: - *BaseCoordinator

    override func start() {
        showTabBar()
    }

    // MARK: - Private Methods

    private func showTabBar() {
        guard let tabBarController = assembly?.makeTabBar() else { return }

        self.tabBarController = tabBarController

        setupTabs()

        navigationController?.viewControllers.removeAll()
        navigationController?.pushViewController(tabBarController, animated: false)
    }

    private func setupTabs() {
        let tabItems = TabBarItem.allCases

        guard
            let tabBarController,
            tabItems != tabBarController.customTabs.compactMap({ $0.itemDescriptor as? TabBarItem }),
            let exchangeController = setupExchangeAndReturn(),
            let historyController = setupHistoryAndReturn()
        else { return }

        tabBarController.customTabs = tabItems.map {
            switch $0 {
            case .exchange:
                exchangeController.tabBarItem = UITabBarItem(
                    title: $0.displayTitle,
                    image: $0.image,
                    selectedImage: $0.selectedImage
                )

                return TabBarControllerItem(itemDescriptor: $0, controller: exchangeController)

            case .history:
                historyController.tabBarItem = UITabBarItem(
                    title: $0.displayTitle,
                    image: $0.image,
                    selectedImage: $0.selectedImage
                )
                
                return TabBarControllerItem(itemDescriptor: $0, controller: historyController)
            }
        }
    }

    private func setupExchangeAndReturn() -> UIViewController? {
        guard let coordinator = assembly?.makeExchangeAssembly().coordinator() else { return nil }
        coordinator.start()
        add(child: coordinator)

        return coordinator.navigationController
    }

    private func setupHistoryAndReturn() -> UIViewController? {
        guard let coordinator = assembly?.makeHistoryAssembly().coordinator() else { return nil }
        coordinator.start()
        add(child: coordinator)

        return coordinator.navigationController
    }
}

// MARK: - TabBarCoordinatorInterface

extension TabBarCoordinator: TabBarCoordinatorInterface {}
