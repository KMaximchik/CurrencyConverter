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
        guard
            let history = assembly?.makeHistory(
                onNavigate: { [weak self] event in
                    switch event {
                    case .goSearch:
                        self?.showHistorySearch()
                    }
                }
            )
        else { return }

        navigationController?.pushViewController(history, animated: true)
    }

    private func showHistorySearch() {
        guard
            let historySearch = assembly?.makeHistorySearch(
                onNavigate: { [weak self] event in
                    switch event {
                    case .goBack:
                        self?.navigationController?.dismiss(animated: true)
                    }
                }
            )
        else { return }

        navigationController?.present(historySearch, animated: true)
    }
}

// MARK: - HistoryCoordinatorInterface

extension HistoryCoordinator: HistoryCoordinatorInterface {}
