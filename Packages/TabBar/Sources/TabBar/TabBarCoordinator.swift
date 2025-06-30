import DesignSystem
import SwiftUI
import UseCases
import History
import Exchange

// MARK: - TabBarCoordinator

public struct TabBarCoordinator: View {
    // MARK: - Private Properties

    @State private var selectedTab = TabBarItem.exchange

    private let useCasesAssembly: UseCasesAssemblyInterface

    // MARK: - Init

    public init(useCasesAssembly: UseCasesAssemblyInterface) {
        self.useCasesAssembly = useCasesAssembly
    }

    // MARK: - Views

    public var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabBarItem.allCases) { item in
                Group {
                    switch item {
                    case .exchange:
                        ExchangeCoordinator(useCasesAssembly: useCasesAssembly)

                    case .history:
                        HistoryCoordinator(useCasesAssembly: useCasesAssembly)
                    }
                }
                .tabItem {
                    item.image

                    Text(item.displayTitle)
                }
                .tag(item)
            }
        }
    }
}
