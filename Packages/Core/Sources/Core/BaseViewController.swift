import UIKit
import Combine

// MARK: - BaseViewControllerInterface

public protocol BaseViewControllerInterface: AnyObject {
    var cancellables: Set<AnyCancellable> { get }
}

// MARK: - BaseViewController

open class BaseViewController: UIViewController, BaseViewControllerInterface {
    // MARK: - Public Properties

    public var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
