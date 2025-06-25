import SwiftUI

// MARK: - CCEmptyView

public struct CCEmptyView: View {
    // MARK: - Private Properties

    private let icon: Image?
    private let title: String
    private let message: String?

    // MARK: - Init

    public init(icon: Image?, title: String, message: String?) {
        self.icon = icon
        self.title = title
        self.message = message
    }

    // MARK: - Views

    public var body: some View {
        VStack(spacing: .zero) {
            if let icon {
                icon
                    .font(CCFont.largeTitle.weight(.semibold))
                    .foregroundStyle(CCColor.accentBlue.color)
            }

            Spacer()
                .frame(maxHeight: CCSpacing.md)

            Text(title)
                .font(CCFont.body)
                .foregroundStyle(CCColor.labelPrimary.color)
                .multilineTextAlignment(.center)

            Spacer()
                .frame(maxHeight: CCSpacing.sm)

            if let message {
                Text(message)
                    .font(CCFont.footnote)
                    .foregroundStyle(CCColor.labelSecondary.color)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
