import SwiftUI
import DesignSystem

// MARK: - HistoryView

struct HistoryView<ViewModel: HistoryViewModelInterface>: View {
    // MARK: - Private Properties

    @ObservedObject private var viewModel: ViewModel

    // MARK: - Init

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    var body: some View {
        VStack {
            Text("History")
                .foregroundStyle(CCColor.accentGreen.color)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CCColor.backgroundPrimary.color)
    }
}
