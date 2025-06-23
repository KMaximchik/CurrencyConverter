import UIKit

// MARK: - BaseCoordinatorInterface

public protocol BaseCoordinatorInterface: AnyObject {
    var navigationController: UINavigationController? { get }
    var children: [BaseCoordinatorInterface] { get }

    func start()
}

// MARK: - BaseCoordinator

open class BaseCoordinator: NSObject, BaseCoordinatorInterface {
    // MARK: - Open Properties

    open var navigationController: UINavigationController?
    open var children = [BaseCoordinatorInterface]()

    // MARK: - Init

    public init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    // MARK: - *BaseCoordinatorInterface

    open func start() {
        fatalError("this method must be overridden")
    }

    // MARK: - Public Methods

    public func add(child coordinator: BaseCoordinatorInterface) {
        children.append(coordinator)
    }

    public func remove(child coordinator: BaseCoordinatorInterface) {
        children = children.filter { coordinator !== $0 }
    }
}
