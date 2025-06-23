import Core
import UIKit

// MARK: - HistoryCoordinatorInterface

protocol HistoryCoordinatorInterface: BaseCoordinatorInterface {}

// MARK: - HistoryCoordinator

final class HistoryCoordinator: BaseCoordinator {
    // MARK: - Private Properties

    private weak var assembly: HistoryAssemblyInterface?

    // MARK: - Init

    init(assembly: HistoryAssemblyInterface, navigationController: UINavigationController?) {
        self.assembly = assembly

        super.init(navigationController: navigationController)
    }

    // MARK: - *BaseCoordinator

    override func start() {
        showHistory()
    }

    // MARK: - Private Methods

    private func showHistory() {
        guard let history = assembly?.makeHistory() else { return }

        navigationController?.pushViewController(history, animated: true)
    }
}

// MARK: - HistoryCoordinatorInterface

extension HistoryCoordinator: HistoryCoordinatorInterface {}
