import SwiftUI

// MARK: - CCSpinner

public struct CCSpinner: View {
    // MARK: - Nested Types

    public enum Size {
        case medium

        var size: CGFloat {
            switch self {
            case .medium:
                32
            }
        }
    }

    // MARK: - Private Properties

    @State private var isAnimating = false

    private let size: Size

    // MARK: - Init

    public init(size: Size = .medium) {
        self.size = size
    }

    // MARK: - Views

    public var body: some View {
        Circle()
            .trim(from: .zero, to: 0.7)
            .stroke(
                CCColor.accentBlue.color,
                style: StrokeStyle(
                    lineWidth: 4,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(isAnimating ? 360 : .zero))
            .animation(
                .linear(duration: 1).repeatForever(autoreverses: false),
                value: isAnimating
            )
            .frame(maxWidth: size.size, maxHeight: size.size)
            .onAppear {
                isAnimating = true
            }
    }
}
