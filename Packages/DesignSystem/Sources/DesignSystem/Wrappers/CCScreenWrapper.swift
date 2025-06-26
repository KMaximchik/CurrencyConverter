import SwiftUI

// MARK: - CCScreenWrapper

public struct CCScreenWrapper<Content: View>: View {
    // MARK: - Private Properties

    private let content: Content
    private let state: CCScreenState

    // MARK: - Init

    public init(
        state: CCScreenState,
        @ViewBuilder content: () -> Content
    ) {
        self.state = state
        self.content = content()
    }

    // MARK: - Views

    public var body: some View {
        content
            .overlay(alignment: .top) {
                additionalView
            }
    }

    @ViewBuilder
    private var additionalView: some View {
        VStack {
            switch state {
            case .loading:
                loader
                    .transition(.opacity)

            case .pending:
                EmptyView()

            case let .error(text):
                makePopupView(text: text)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: state)
    }

    @ViewBuilder
    private var loader: some View {
        ZStack {
            CCBackdropBlurView(radius: 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            CCSpinner()
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    private func makePopupView(text: String) -> some View {
        HStack(spacing: .zero) {
            Text(text)
                .font(CCFont.subheadline)
                .foregroundStyle(CCColor.labelPrimaryInvariably.color)

            Spacer()
        }
        .padding(.horizontal, CCSpacing.lg)
        .padding(.vertical, CCSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: CCCornerRadius.sm)
                .foregroundStyle(CCColor.accentRed.color)
        )
        .padding(.top, CCSpacing.sm)
        .padding(.horizontal, CCSpacing.lg)
    }
}
