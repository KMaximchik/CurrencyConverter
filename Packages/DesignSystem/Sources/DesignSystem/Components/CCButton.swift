import SwiftUI

// MARK: - CCButton

public struct CCButton: View {
    // MARK: - Nested Types

    public enum Size {
        case medium

        var height: CGFloat {
            switch self {
            case .medium:
                42
            }
        }

        var font: Font {
            switch self {
            case .medium:
                CCFont.subheadline.weight(.medium)
            }
        }
    }

    public enum Variant {
        case primary, error

        var color: Color {
            switch self {
            case .primary:
                CCColor.accentBlue.color

            case .error:
                CCColor.accentRed.color
            }
        }
    }

    // MARK: - Private Properties

    private let size: Size
    private let variant: Variant
    private let title: String
    private let isBig: Bool
    private let enabled: Bool
    private let onTap: () -> Void

    // MARK: - Init

    public init(
        size: Size = .medium,
        variant: Variant = .primary,
        title: String,
        isBig: Bool = false,
        enabled: Bool = true,
        onTap: @escaping () -> Void
    ) {
        self.size = size
        self.variant = variant
        self.title = title
        self.isBig = isBig
        self.enabled = enabled
        self.onTap = onTap
    }

    // MARK: - Views

    public var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: CCSpacing.sm) {
                Text(title)
                    .font(size.font)
                    .foregroundStyle(CCColor.labelPrimaryInvariably.color.opacity(enabled ? 1 : 0.75))
                    .textCase(.uppercase)
            }
            .frame(maxWidth: isBig ? .infinity : nil)
            .frame(height: size.height)
            .background(
                RoundedRectangle(cornerRadius: CCCornerRadius.sm)
                    .foregroundStyle(enabled ? variant.color : CCColor.separatorPrimary.color)
            )
        }
        .disabled(!enabled)
    }
}
