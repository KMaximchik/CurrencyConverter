import Core
import UIKit
import UseCases

// MARK: - ExchangeAssemblyInterface

protocol ExchangeAssemblyInterface: BaseAssemblyInterface {
    func makeExchange() -> ExchangeViewController<ExchangeViewModel>
}

// MARK: - ExchangeAssembly

public final class ExchangeAssembly: BaseAssembly {
    // MARK: - Private Properties

    private let useCasesAssembly: UseCasesAssemblyInterface

    // MARK: - Init

    public init(useCasesAssembly: UseCasesAssemblyInterface) {
        self.useCasesAssembly = useCasesAssembly
    }

    // MARK: - *BaseAssembly

    public override func coordinator(navigationController: UINavigationController?) -> BaseCoordinatorInterface {
        ExchangeCoordinator(assembly: self, navigationController: navigationController)
    }

    public override func coordinator() -> BaseCoordinatorInterface {
        ExchangeCoordinator(assembly: self, navigationController: UINavigationController())
    }
}

// MARK: - ExchangeAssemblyInterface

extension ExchangeAssembly: ExchangeAssemblyInterface {
    func makeExchange() -> ExchangeViewController<ExchangeViewModel> {
        let viewModel = ExchangeViewModel()
        let suiView = ExchangeView(viewModel: viewModel)
        let hostingController = BaseHostingController(rootView: suiView, ignoresKeyboard: true)
        let viewController = ExchangeViewController(
            viewModel: viewModel,
            suiView: suiView,
            hostingController: hostingController
        )

        return viewController
    }
}
