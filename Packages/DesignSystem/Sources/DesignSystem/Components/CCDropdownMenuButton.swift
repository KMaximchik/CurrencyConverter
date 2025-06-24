import SwiftUI

// MARK: - CCDropdownMenuButton

public struct CCDropdownMenuButton: View {
    // MARK: - Private Properties

    @Binding private var selectedOption: String?

    private let placeholder: String
    private let options: [String]

    // MARK: - Init

    public init(
        selectedOption: Binding<String?>,
        placeholder: String,
        options: [String]
    ) {
        self._selectedOption = selectedOption
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
                    .font(CCFont.body)
                    .foregroundStyle(CCColor.labelPrimaryInvariably.color)
                    .textCase(.uppercase)

                CCIcon.System.arrowsUpDownIcon.image
                    .font(CCFont.body)
                    .foregroundStyle(CCColor.labelPrimaryInvariably.color)
            }
            .padding(.vertical, CCSpacing.md)
            .padding(.horizontal, CCSpacing.lg)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: CCCornerRadius.sm)
                    .foregroundStyle(CCColor.accentBlue.color)
            )
        }
    }
}
