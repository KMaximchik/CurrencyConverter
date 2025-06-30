import SwiftUI
import FlowStacks
import UseCases
import TabBar
import DesignSystem

// MARK: - CurrencyConverterApp

@main
struct CurrencyConverterApp: App {
    // MARK: - Private Properties

    private let useCasesAssembly: UseCasesAssemblyInterface = UseCasesAssembly()

    // MARK: - Init

    init() {
        setupTabBar()
    }

    // MARK: - Views

    var body: some Scene {
        WindowGroup {
            TabBarCoordinator(useCasesAssembly: useCasesAssembly)
        }
    }

    // MARK: - Private Methods

    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = CCColor.backgroundSecondary.uiColor
        appearance.stackedLayoutAppearance.normal.iconColor = CCColor.labelSecondary.uiColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: CCColor.labelSecondary.uiColor
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = CCColor.accentBlue.uiColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: CCColor.accentBlue.uiColor
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
