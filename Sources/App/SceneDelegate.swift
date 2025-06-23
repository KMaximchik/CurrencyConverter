import UIKit
import Core
import TabBar
import UseCases

// MARK: - SceneDelegate

class SceneDelegate: UIResponder {
    // MARK: - Internal Properties

    var window: UIWindow?

    // MARK: - Private Properties

    private var useCasesAssembly: UseCasesAssemblyInterface = UseCasesAssembly()
    private var coordinator: BaseCoordinatorInterface?
    private var assembly: BaseAssemblyInterface?

    // MARK: - Private Methods

    private func setupTabBar() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let tabBarAssembly = TabBarAssembly(useCasesAssembly: useCasesAssembly)
        let coordinator = tabBarAssembly.coordinator()
        self.coordinator = coordinator

        window.rootViewController = coordinator.navigationController
        self.window = window
        window.makeKeyAndVisible()
        coordinator.start()

        assembly = tabBarAssembly
    }
}

// MARK: - UIWindowSceneDelegate

extension SceneDelegate: UIWindowSceneDelegate {
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setupTabBar()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
