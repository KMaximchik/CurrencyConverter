import SwiftUI
import DesignSystem

// MARK: - HistoryView

struct HistoryView<ViewModel: HistoryViewModelInterface>: View {
    // MARK: - Private Properties

    @State private var showFilterView = false

    @ObservedObject private var viewModel: ViewModel

    // MARK: - Init

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    var body: some View {
        CCScreenWrapper(state: viewModel.screenState) {
            VStack(spacing: CCSpacing.lg) {
                navBar

                if viewModel.filteredExchanges.isEmpty {
                    emptyView
                } else {
                    content
                }
            }
            .greedySize()
            .background(CCColor.backgroundPrimary.color)
        }
        .onAppear {
            viewModel.handleInput(.onAppear)
        }
    }

    @ViewBuilder
    private var navBar: some View {
        CCNavigationBar(
            title: {
                Text("History.nav.title")
                    .font(CCFont.body)
                    .foregroundStyle(CCColor.labelPrimary.color)
            },
            right: {
                Button {
                    withAnimation {
                        showFilterView.toggle()
                    }
                } label: {
                    (showFilterView ? CCIcon.System.xmarkIcon : CCIcon.System.magnifyingglassIcon).image
                        .font(CCFont.body)
                        .foregroundStyle(CCColor.labelPrimary.color)
                }
            }
        )
    }

    @ViewBuilder
    private var emptyView: some View {
        VStack {
            searchView

            Spacer()

            CCEmptyView(
                icon: CCIcon.System.pencilListClipboardIcon.image,
                title: "History.empty.title".localized(),
                message: "History.empty.message".localized()
            )
            .padding(.horizontal, CCSpacing.lg)

            Spacer()
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: .zero) {
            searchView

            exchangesList
                .padding(.horizontal, CCSpacing.lg)

            Spacer()
        }
    }

    @ViewBuilder
    private var searchView: some View {
        if showFilterView {
            filterView
                .transition(.opacity)
        }
    }

    @ViewBuilder
    private var filterView: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                Text("History.search.tip.title")
                    .font(CCFont.caption)
                    .foregroundStyle(CCColor.labelSecondary.color)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, CCSpacing.lg)

            Spacer()
                .frame(height: CCSpacing.sm)

            HStack(spacing: CCSpacing.md) {
                CCDropdownMenuButton(
                    selectedOption: $viewModel.fromCurrencyCode,
                    size: .medium,
                    placeholder: "History.search.button.initial.caption".localized(),
                    options: viewModel.availableFromCurrencies.map { $0.rawValue }
                )

                Button {
                    viewModel.handleInput(.onTapSwapButton)
                } label: {
                    CCIcon.System.arrowsLeftRightIcon.image
                        .font(CCFont.body)
                        .foregroundStyle(CCColor.labelPrimary.color)
                }

                CCDropdownMenuButton(
                    selectedOption: $viewModel.toCurrencyCode,
                    size: .medium,
                    placeholder: "History.search.button.result.caption".localized(),
                    options: viewModel.availableToCurrencies.map { $0.rawValue }
                )
            }
            .padding(.horizontal, CCSpacing.lg)

            Spacer()
                .frame(height: CCSpacing.sm)

            HStack(spacing: CCSpacing.sm) {
                CCButton(
                    title: "Common.search".localized(),
                    isBig: true,
                    enabled: viewModel.searchButtonEnabled
                ) {
                    viewModel.handleInput(.onTapSearchButton)
                }

                CCButton(
                    variant: .error,
                    title: "Common.reset".localized(),
                    isBig: true
                ) {
                    viewModel.handleInput(.onTapResetButton)
                }
            }
            .padding(.horizontal, CCSpacing.lg)

            Spacer()
                .frame(height: CCSpacing.md)

            Divider()
                .foregroundStyle(CCColor.separatorPrimary.color)
        }
    }

    @ViewBuilder
    private var exchangesList: some View {
        List {
            Section {
                ForEach(viewModel.filteredExchanges, id: \.id) { exchange in
                    HistoryListItemView(exchange: exchange)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
                        .listRowBackground(Color.clear)
                }
            }
        }
        .background(.clear)
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}
