import SwiftUI

// MARK: - CCNavigationBar

public struct CCNavigationBar<Left: View, Title: View, Right: View>: View {
    // MARK: - Private Properties

    private let left: () -> Left
    private let title: () -> Title
    private let right: () -> Right
    
    // MARK: - Init

    public init(
        @ViewBuilder left: @escaping () -> Left = { Color.clear.frame(width: 44, height: 44) },
        @ViewBuilder title: @escaping () -> Title = { Color.clear },
        @ViewBuilder right: @escaping () -> Right = { Color.clear.frame(width: 44, height: 44) }
    ) {
        self.left = left
        self.title = title
        self.right = right
    }

    // MARK: - Views

    public var body: some View {
        VStack(spacing: .zero) {
            ZStack(alignment: .center) {
                HStack(spacing: CCSpacing.md) {
                    left()
                        .frame(maxHeight: 44)

                    Spacer()

                    right()
                        .frame(maxHeight: 44)
                }

                title()
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, CCSpacing.lg)

            Divider()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundStyle(CCColor.separatorSecondary.color)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(CCColor.backgroundPrimary.color)
    }
}
