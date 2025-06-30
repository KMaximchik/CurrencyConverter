import SwiftUI
import FlowStacks
import UseCases

// MARK: - ExchangeCoordinator

public struct ExchangeCoordinator: View {
    // MARK: - Nested Types

    enum Screen: Hashable {}

    // MARK: - Private Properties

    @State private var routes = Routes<Screen>()

    private let useCasesAssembly: UseCasesAssemblyInterface

    // MARK: - Init

    public init(useCasesAssembly: UseCasesAssemblyInterface) {
        self.useCasesAssembly = useCasesAssembly
    }

    // MARK: - Views

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            ExchangeView(
                viewModel: ExchangeViewModel(
                    currenciesUseCase: useCasesAssembly.currenciesUseCase,
                    historyUseCase: useCasesAssembly.historyUseCase
                )
            )
        }
    }
}
