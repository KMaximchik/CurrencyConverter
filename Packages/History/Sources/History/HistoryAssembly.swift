import Core
import UIKit
import UseCases

// MARK: - HistoryAssemblyInterface

protocol HistoryAssemblyInterface: BaseAssemblyInterface {
    func makeHistory() -> HistoryViewController<HistoryViewModel>
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
    func makeHistory() -> HistoryViewController<HistoryViewModel> {
        let viewModel = HistoryViewModel(historyUseCase: useCasesAssembly.historyUseCase)
        let suiView = HistoryView(viewModel: viewModel)
        let hostingController = BaseHostingController(rootView: suiView, ignoresKeyboard: true)
        let viewController = HistoryViewController(
            viewModel: viewModel,
            suiView: suiView,
            hostingController: hostingController
        )

        return viewController
    }
}
