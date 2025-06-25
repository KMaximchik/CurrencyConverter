import SwiftUI

// MARK: - CCDropdownMenuButton

public struct CCDropdownMenuButton: View {
    // MARK: - Nested Types

    public enum Size {
        case large, medium

        var horizontalPadding: CGFloat {
            switch self {
            case .large:
                CCSpacing.lg

            case .medium:
                CCSpacing.md
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .large:
                CCSpacing.md

            case .medium:
                CCSpacing.sm
            }
        }

        var font: Font {
            switch self {
            case .large:
                CCFont.body

            case .medium:
                CCFont.subheadline
            }
        }
    }

    // MARK: - Private Properties

    @Binding private var selectedOption: String?

    private let size: Size
    private let placeholder: String
    private let options: [String]

    // MARK: - Init

    public init(
        selectedOption: Binding<String?>,
        size: Size = .large,
        placeholder: String,
        options: [String]
    ) {
        self._selectedOption = selectedOption
        self.size = size
        self.placeholder = placeholder
        self.options = options
    }

    // MARK: - Views

    public var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selectedOption = option
                }
            }
        } label: {
            HStack(spacing: CCSpacing.md) {
                Text(selectedOption ?? placeholder)
                    .font(size.font)
                    .foregroundStyle(CCColor.labelPrimaryInvariably.color)
                    .textCase(.uppercase)

                CCIcon.System.arrowsUpDownIcon.image
                    .font(size.font)
                    .foregroundStyle(CCColor.labelPrimaryInvariably.color)
            }
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: CCCornerRadius.sm)
                    .foregroundStyle(CCColor.accentBlue.color)
            )
        }
    }
}
