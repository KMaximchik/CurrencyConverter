import SwiftUI
import Core
import Extensions
import DesignSystem

// MARK: - HistoryViewController

final class HistoryViewController<ViewModel: HistoryViewModelInterface>: BaseViewController {
    // MARK: - Private Properties

    private let viewModel: ViewModel
    private let suiView: HistoryView<ViewModel>
    private var hostingController: BaseHostingController<HistoryView<ViewModel>>

    // MARK: - Init

    init(
        viewModel: ViewModel,
        suiView: HistoryView<ViewModel>,
        hostingController: BaseHostingController<HistoryView<ViewModel>>
    ) {
        self.suiView = suiView
        self.viewModel = viewModel
        self.hostingController = hostingController

        super.init()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
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
}
