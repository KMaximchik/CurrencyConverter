import SwiftUI

// MARK: - CCDecimalInput

public struct CCDecimalInput: View {
    // MARK: - Private Properties

    @FocusState.Binding private var focused: Bool

    @Binding private var value: Decimal

    @State private var text = ""

    private let defaultValue: Decimal
    private let caption: String
    private let maximumFractionDigits: Int
    private let disabled: Bool

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.minimumFractionDigits = .zero
        formatter.maximumFractionDigits = maximumFractionDigits

        return formatter
    }

    // MARK: - Init

    public init(
        focused: FocusState<Bool>.Binding,
        value: Binding<Decimal>,
        defaultValue: Decimal = .zero,
        caption: String,
        maximumFractionDigits: Int,
        disabled: Bool = false
    ) {
        self._focused = focused
        self._value = value
        self.defaultValue = defaultValue
        self.caption = caption
        self.maximumFractionDigits = maximumFractionDigits
        self.disabled = disabled
    }

    // MARK: - Views

    public var body: some View {
        VStack(alignment: .leading, spacing: CCSpacing.sm) {
            HStack(spacing: .zero) {
                Text(caption)
                    .font(CCFont.caption)
                    .foregroundStyle(CCColor.labelSecondary.color)
                    .textCase(.uppercase)

                Spacer()
            }

            textField
        }
    }

    @ViewBuilder
    private var textField: some View {
        TextField("", text: $text)
            .font(CCFont.body)
            .foregroundStyle(disabled ? CCColor.separatorPrimary.color : CCColor.labelPrimary.color)
            .padding(.horizontal, CCSpacing.md)
            .padding(.vertical, CCSpacing.sm)
            .frame(maxWidth: .infinity)
            .focused($focused)
            .keyboardType(.decimalPad)
            .background(
                RoundedRectangle(cornerRadius: CCCornerRadius.sm)
                    .stroke(
                        focused ? CCColor.accentBlue.color : CCColor.separatorPrimary.color,
                        lineWidth: 1
                    )
                    .foregroundStyle(CCColor.backgroundSecondary.color)
            )
            .disabled(disabled)
            .onChange(of: text) { _, newValue in
                text = filteredInput(from: newValue)
                value = makeDecimal(from: text)
            }
            .onAppear {
                text = formattedString(from: value)
            }
            .onChange(of: value) { _, newValue in
                text = formattedString(from: newValue)
            }
            .onChange(of: focused) { _, newValue in
                if !newValue, text.isEmpty {
                    text = formattedString(from: defaultValue)
                    value = defaultValue
                }
            }
    }

    // MARK: - Private Methods

    private func filteredInput(from string: String) -> String {
        let allowedCharacters = "0123456789,"
        var filteredText = string.filter { allowedCharacters.contains($0) }

        if let firstDotIndex = filteredText.firstIndex(of: ",") {
            filteredText = filteredText.enumerated()
                .filter { index, char in
                    char != "," || index == filteredText.distance(from: filteredText.startIndex, to: firstDotIndex)
                }
                .map { String($0.element) }
                .joined()
        }

        while
            filteredText.count > 1,
            filteredText.first == "0",
            filteredText[filteredText.index(filteredText.startIndex, offsetBy: 1)] != "," {
            filteredText.removeFirst()
        }

        if let dotIndex = filteredText.firstIndex(of: ",") {
            let integerPart = String(filteredText[..<dotIndex])
            let fractionalPart = String(filteredText[filteredText.index(after: dotIndex)...])
            let limitedFraction = String(fractionalPart.prefix(maximumFractionDigits))
            filteredText = integerPart + "," + limitedFraction
        }

        if filteredText.isEmpty {
            filteredText = "0"
        }

        return filteredText
    }

    private func makeDecimal(from string: String) -> Decimal {
        numberFormatter.number(from: string)?.decimalValue ?? .zero
    }

    private func formattedString(from decimal: Decimal) -> String {
        numberFormatter.string(from: NSDecimalNumber(decimal: decimal)) ?? ""
    }
}
