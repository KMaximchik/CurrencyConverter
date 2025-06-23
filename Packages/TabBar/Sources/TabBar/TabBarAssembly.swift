import UIKit
import Core
import Exchange
import History
import UseCases

// MARK: - TabBarAssemblyInterface

protocol TabBarAssemblyInterface: BaseAssemblyInterface {
    func makeTabBar() -> TabBarController
    func makeExchangeAssembly() -> BaseAssemblyInterface
    func makeHistoryAssembly() -> BaseAssemblyInterface
}

// MARK: - TabBarAssembly

public final class TabBarAssembly: BaseAssembly {
    // MARK: - Private Properties

    private let useCasesAssembly: UseCasesAssemblyInterface

    private var exchangeAssembly: BaseAssemblyInterface?
    private var historyAssembly: BaseAssemblyInterface?

    // MARK: - Init

    public init(useCasesAssembly: UseCasesAssemblyInterface) {
        self.useCasesAssembly = useCasesAssembly
    }

    // MARK: - *BaseAssembly

    public override func coordinator(navigationController: UINavigationController?) -> BaseCoordinatorInterface {
        TabBarCoordinator(assembly: self, navigationController: navigationController)
    }

    public override func coordinator() -> BaseCoordinatorInterface {
        TabBarCoordinator(assembly: self, navigationController: UINavigationController())
    }
}

// MARK: - TabBarAssemblyInterface

extension TabBarAssembly: TabBarAssemblyInterface {
    func makeTabBar() -> TabBarController {
        TabBarController()
    }

    func makeExchangeAssembly() -> BaseAssemblyInterface {
        let assembly = ExchangeAssembly(useCasesAssembly: useCasesAssembly)
        exchangeAssembly = assembly
        return assembly
    }

    func makeHistoryAssembly() -> BaseAssemblyInterface {
        let assembly = HistoryAssembly(useCasesAssembly: useCasesAssembly)
        historyAssembly = assembly
        return assembly
    }
}
