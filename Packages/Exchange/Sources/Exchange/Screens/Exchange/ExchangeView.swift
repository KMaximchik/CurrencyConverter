import SwiftUI
import DesignSystem

// MARK: - ExchangeView

struct ExchangeView<ViewModel: ExchangeViewModelInterface>: View {
    // MARK: - Private Properties

    @ObservedObject private var viewModel: ViewModel

    // MARK: - Init

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    var body: some View {
        VStack {
            Text("Exchange")
                .foregroundStyle(CCColor.accentGreen.color)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CCColor.backgroundPrimary.color)
    }
}
