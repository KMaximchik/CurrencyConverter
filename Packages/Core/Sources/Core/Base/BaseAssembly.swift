import UIKit

// MARK: - BaseAssemblyInterface

public protocol BaseAssemblyInterface: AnyObject {
    func coordinator(navigationController: UINavigationController?) -> BaseCoordinatorInterface
    func coordinator() -> BaseCoordinatorInterface
}

// MARK: - BaseAssembly

open class BaseAssembly: BaseAssemblyInterface {
    // MARK: - Init

    public init() {}

    // MARK: - *BaseAssemblyInterface

    open func coordinator(navigationController: UINavigationController?) -> BaseCoordinatorInterface {
        fatalError("this method must be overridden")
    }

    open func coordinator() -> BaseCoordinatorInterface {
        fatalError("this method must be overridden")
    }
}
