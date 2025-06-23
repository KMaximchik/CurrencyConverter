import SwiftUI
import Core
import Extensions
import DesignSystem

// MARK: - HistoryViewController

final class HistoryViewController<ViewModel: HistoryViewModelInterface>: BaseViewController {
    // MARK: - Private Properties

    private let viewModel: ViewModel
    private let suiView: HistoryView<ViewModel>
    private var hostingController: BaseHostingController<HistoryView<ViewModel>>?

    // MARK: - Init

    init(viewModel: ViewModel, suiView: HistoryView<ViewModel>) {
        self.suiView = suiView
        self.viewModel = viewModel

        super.init()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Privtae Methods

    private func setup() {
        hostingController = embedAndReturn(suiView: suiView)
    }

    private func embedAndReturn<V: View>(suiView: V) -> BaseHostingController<V> {
        let hostingController = BaseHostingController(
            rootView: suiView,
            ignoresKeyboard: true
        )

        hostingController.view.backgroundColor = CCColor.backgroundPrimary.uiColor
        hostingController.willMove(toParent: self)
        addChild(hostingController)
        view.willMove(toSuperview: hostingController.view)
        hostingController.view.embed(in: view)
        hostingController.didMove(toParent: self)

        return hostingController
    }
}
