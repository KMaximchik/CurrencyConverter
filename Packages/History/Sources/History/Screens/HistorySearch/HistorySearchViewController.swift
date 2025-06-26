import SwiftUI
import Core
import Utilities
import DesignSystem

// MARK: - HistorySearchViewController

final class HistorySearchViewController<ViewModel: HistorySearchViewModelInterface>: BaseViewController {
    // MARK: - Nested Types

    enum NavigationEvent {
        case goBack
    }

    // MARK: - Private Properties

    private let viewModel: ViewModel
    private let suiView: HistorySearchView<ViewModel>
    private var hostingController: BaseHostingController<HistorySearchView<ViewModel>>
    private let onNavigate: ((NavigationEvent) -> Void)?

    // MARK: - Init

    init(
        viewModel: ViewModel,
        suiView: HistorySearchView<ViewModel>,
        hostingController: BaseHostingController<HistorySearchView<ViewModel>>,
        onNavigate: ((NavigationEvent) -> Void)? = nil
    ) {
        self.suiView = suiView
        self.viewModel = viewModel
        self.hostingController = hostingController
        self.onNavigate = onNavigate

        super.init()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupBindings()
    }

    // MARK: - Privtae Methods

    private func setup() {
        hostingController.view.backgroundColor = CCColor.backgroundPrimary.uiColor
        hostingController.willMove(toParent: self)
        addChild(hostingController)
        view.willMove(toSuperview: hostingController.view)
        hostingController.view.embed(in: view)
        hostingController.didMove(toParent: self)
    }

    private func setupBindings() {
        viewModel.outputPublisher
            .sink { [weak self] event in
                switch event {
                case .goBack:
                    self?.onNavigate?(.goBack)
                }
            }
            .store(in: &cancellables)
    }
}
