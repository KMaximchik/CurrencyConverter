import SwiftUI
import FlowStacks
import UseCases

// MARK: - HistoryCoordinator

public struct HistoryCoordinator: View {
    // MARK: - Nested Types
    
    enum Screen: Hashable {
        case historySearch
    }
    
    // MARK: - Private Properties
    
    @State private var path = FlowPath()

    private let useCasesAssembly: UseCasesAssemblyInterface
    
    // MARK: - Init
    
    public init(useCasesAssembly: UseCasesAssemblyInterface) {
        self.useCasesAssembly = useCasesAssembly
    }
    
    // MARK: - Views
    
    public var body: some View {
        FlowStack($path, withNavigation: true) {
            HistoryView(
                viewModel: HistoryViewModel(
                    historyUseCase: useCasesAssembly.historyUseCase
                )
            )
            .flowDestination(for: Screen.self) { screen in
                switch screen {
                case .historySearch:
                    HistorySearchView(
                        viewModel: HistorySearchViewModel(
                            historyUseCase: useCasesAssembly.historyUseCase
                        )
                    )   
                }
            }
        }
    }
}
