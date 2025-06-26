import Core
import UIKit
import UseCases

// MARK: - HistoryAssemblyInterface

protocol HistoryAssemblyInterface: BaseAssemblyInterface {
    func makeHistory(
        onNavigate: ((HistoryViewController<HistoryViewModel>.NavigationEvent) -> Void)?
    ) -> HistoryViewController<HistoryViewModel>
    func makeHistorySearch(
        onNavigate: ((HistorySearchViewController<HistorySearchViewModel>.NavigationEvent) -> Void)?
    ) -> HistorySearchViewController<HistorySearchViewModel>
}

// MARK: - HistoryAssembly

public final class HistoryAssembly: BaseAssembly {
    // MARK: - Private Properties

    private let useCasesAssembly: UseCasesAssemblyInterface

    // MARK: - Init

    public init(useCasesAssembly: UseCasesAssemblyInterface) {
        self.useCasesAssembly = useCasesAssembly
    }

    // MARK: - *BaseAssembly

    public override func coordinator(navigationController: UINavigationController?) -> BaseCoordinatorInterface {
        HistoryCoordinator(assembly: self, navigationController: navigationController)
    }

    public override func coordinator() -> BaseCoordinatorInterface {
        HistoryCoordinator(assembly: self, navigationController: UINavigationController())
    }
}

// MARK: - HistoryAssemblyInterface

extension HistoryAssembly: HistoryAssemblyInterface {
    func makeHistory(
        onNavigate: ((HistoryViewController<HistoryViewModel>.NavigationEvent) -> Void)?
    ) -> HistoryViewController<HistoryViewModel> {
        let viewModel = HistoryViewModel(historyUseCase: useCasesAssembly.historyUseCase)
        let suiView = HistoryView(viewModel: viewModel)
        let hostingController = BaseHostingController(rootView: suiView, ignoresKeyboard: true)
        let viewController = HistoryViewController(
            viewModel: viewModel,
            suiView: suiView,
            hostingController: hostingController,
            onNavigate: onNavigate
        )

        return viewController
    }

    func makeHistorySearch(
        onNavigate: ((HistorySearchViewController<HistorySearchViewModel>.NavigationEvent) -> Void)?
    ) -> HistorySearchViewController<HistorySearchViewModel> {
        let viewModel = HistorySearchViewModel(historyUseCase: useCasesAssembly.historyUseCase)
        let suiView = HistorySearchView(viewModel: viewModel)
        let hostingController = BaseHostingController(rootView: suiView, ignoresKeyboard: true)
        let viewController = HistorySearchViewController(
            viewModel: viewModel,
            suiView: suiView,
            hostingController: hostingController,
            onNavigate: onNavigate
        )

        return viewController
    }
}
