import SwiftUI
import Core
import Extensions
import DesignSystem

// MARK: - ExchangeViewController

final class ExchangeViewController<ViewModel: ExchangeViewModelInterface>: BaseViewController {
    // MARK: - Private Properties

    private let viewModel: ViewModel
    private let suiView: ExchangeView<ViewModel>
    private var hostingController: BaseHostingController<ExchangeView<ViewModel>>

    // MARK: - Init

    init(
        viewModel: ViewModel,
        suiView: ExchangeView<ViewModel>,
        hostingController: BaseHostingController<ExchangeView<ViewModel>>
    ) {
        self.viewModel = viewModel
        self.suiView = suiView
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
