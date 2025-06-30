import SwiftUI
import DesignSystem
import Utilities

// MARK: - ExchangeView

struct ExchangeView<ViewModel: ExchangeViewModelInterface>: View {
    // MARK: - Private Properties

    @FocusState private var fromInputFocused: Bool
    @FocusState private var toInputFocused: Bool

    @StateObject private var viewModel: ViewModel

    // MARK: - Init

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Views

    var body: some View {
        CCScreenWrapper(state: viewModel.screenState) {
            VStack(spacing: CCSpacing.lg) {
                navBar

                VStack(spacing: CCSpacing.lg) {
                    tip

                    buttons

                    inputs

                    caption

                    Spacer()
                }
                .padding(.horizontal, CCSpacing.lg)
            }
            .greedySize()
            .background(CCColor.backgroundPrimary.color)
        }
        .onAppear {
            viewModel.handleInput(.onAppear)
        }
        .onTapGesture {
            fromInputFocused = false
            toInputFocused = false
        }
    }

    @ViewBuilder
    private var navBar: some View {
        CCNavigationBar(
            title: {
                Text("Exchange.nav.title")
                    .font(CCFont.body)
                    .foregroundStyle(CCColor.labelPrimary.color)
            }
        )
    }

    @ViewBuilder
    private var tip: some View {
        if viewModel.fromCurrencyCode == nil || viewModel.toCurrencyCode == nil {
            HStack(spacing: .zero) {
                Text("Exchange.tip")
                    .font(CCFont.subheadline)
                    .foregroundStyle(CCColor.labelPrimary.color)

                Spacer()
            }
        }
    }

    @ViewBuilder
    private var buttons: some View {
        HStack(spacing: CCSpacing.sm) {
            CCDropdownMenuButton(
                selectedOption: $viewModel.fromCurrencyCode,
                placeholder: "Exchange.button.currency.placeholder".localized(),
                options: viewModel.availableFromCurrencies.map { $0.rawValue }
            )

            Button {
                viewModel.handleInput(.onTapSwapButton)
            } label: {
                CCIcon.System.arrowsLeftRightIcon.image
                    .font(CCFont.body)
                    .foregroundStyle(CCColor.labelPrimary.color)
            }
            .frame(width: 40, height: 40)

            CCDropdownMenuButton(
                selectedOption: $viewModel.toCurrencyCode,
                placeholder: "Exchange.button.currency.placeholder".localized(),
                options: viewModel.availableToCurrencies.map { $0.rawValue }
            )
        }
    }

    @ViewBuilder
    private var inputs: some View {
        VStack(spacing: CCSpacing.md) {
            CCDecimalInput(
                focused: $fromInputFocused,
                value: $viewModel.fromValue,
                defaultValue: viewModel.defaultInputsValue,
                caption: "Exchange.input.from.caption".localized(),
                maximumFractionDigits: viewModel.maximumFractionDigits
            )

            CCDecimalInput(
                focused: $toInputFocused,
                value: $viewModel.toValue,
                defaultValue: viewModel.defaultInputsValue,
                caption: "Exchange.input.to.caption".localized(),
                maximumFractionDigits: viewModel.maximumFractionDigits,
                disabled: true
            )
        }
    }

    @ViewBuilder
    private var caption: some View {
        if let caption = viewModel.caption {
            HStack(spacing: .zero) {
                Text(caption)
                    .font(CCFont.caption)
                    .foregroundStyle(CCColor.separatorSecondary.color)

                Spacer()
            }
        }
    }
}
