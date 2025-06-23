import Core
import UIKit

// MARK: - ExchangeCoordinatorInterface

protocol ExchangeCoordinatorInterface: BaseCoordinatorInterface {}

// MARK: - ExchangeCoordinator

final class ExchangeCoordinator: BaseCoordinator {
    // MARK: - Private Properties

    private weak var assembly: ExchangeAssemblyInterface?

    // MARK: - Init

    init(assembly: ExchangeAssemblyInterface, navigationController: UINavigationController?) {
        self.assembly = assembly

        super.init(navigationController: navigationController)
    }

    // MARK: - *BaseCoordinator

    override func start() {
        showExchange()
    }

    // MARK: - Private Methods

    private func showExchange() {
        guard let exchange = assembly?.makeExchange() else { return }

        navigationController?.pushViewController(exchange, animated: true)
    }
}

// MARK: - ExchangeCoordinatorInterface

extension ExchangeCoordinator: ExchangeCoordinatorInterface {}
