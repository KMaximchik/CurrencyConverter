import SwiftUI
import Domain
import DesignSystem
import Utilities

// MARK: - HistoryListItemView

struct HistoryListItemView: View {
    // MARK: - Private Properties

    private let exchange: Exchange

    // MARK: - Init

    init(exchange: Exchange) {
        self.exchange = exchange
    }

    // MARK: - Views

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                VStack(alignment: .leading, spacing: .zero) {
                    makeText(
                        titleKey: "History.list.item.initial.title",
                        additionalText: "\(exchange.initialValue.toString() ?? "") \(exchange.fromCurrencyCode)",
                        font: CCFont.subheadline
                    )

                    Spacer()
                        .frame(height: CCSpacing.xs)

                    makeText(
                        titleKey: "History.list.item.result.title",
                        additionalText: "\(exchange.value.toString() ?? "") \(exchange.toCurrencyCode)",
                        font: CCFont.subheadline
                    )

                    Spacer()
                        .frame(height: CCSpacing.md)

                    makeText(
                        titleKey: "History.list.item.rate.title",
                        additionalText: "1 \(exchange.fromCurrencyCode) ≈ \(exchange.rateValue.toString() ?? "") \(exchange.toCurrencyCode)",
                        font: CCFont.footnote
                    )
                }

                Spacer()

                VStack(alignment: .trailing, spacing: CCSpacing.sm) {
                    currencyPair

                    Text(exchange.createdAt.format(formatType: .ddMMyyyHHmm))
                        .font(CCFont.caption)
                        .foregroundStyle(CCColor.labelSecondary.color)
                }
            }
            .padding(.vertical, CCSpacing.md)

            Divider()
                .greedyWidth()
                .frame(height: 1)
                .foregroundStyle(CCColor.separatorPrimary.color)
        }
    }

    @ViewBuilder
    private func makeText(
        titleKey: LocalizedStringKey,
        additionalText: String,
        font: Font
    ) -> some View {
        HStack(spacing: CCSpacing.xs) {
            Text(titleKey)
                .foregroundStyle(CCColor.labelPrimary.color)
                .font(font.weight(.semibold))

            Text(additionalText)
                .foregroundStyle(CCColor.separatorSecondary.color)
                .font(font)
        }
    }

    @ViewBuilder
    private var currencyPair: some View {
        HStack(spacing: CCSpacing.sm) {
            makeCurrencyPairItem(currencyCode: exchange.fromCurrencyCode)

            CCIcon.System.arrowRightIcon.image
                .font(CCFont.caption)
                .foregroundStyle(CCColor.labelPrimary.color)

            makeCurrencyPairItem(currencyCode: exchange.toCurrencyCode)
        }
    }

    @ViewBuilder
    private func makeCurrencyPairItem(currencyCode: String) -> some View {
        Text(currencyCode)
            .font(CCFont.subheadline)
            .foregroundStyle(CCColor.labelPrimaryInvariably.color)
            .padding(CCSpacing.sm)
            .background(
                Circle()
                    .foregroundStyle(CCColor.accentBlue.color)
            )
    }
}
