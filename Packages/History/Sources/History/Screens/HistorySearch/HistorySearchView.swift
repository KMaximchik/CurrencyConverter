import SwiftUI
import DesignSystem
import Utilities

// MARK: - HistorySearchView

struct HistorySearchView<ViewModel: HistorySearchViewModelInterface>: View {
    // MARK: - Private Properties

    @State private var showScrollToTopButton = false

    @ObservedObject private var viewModel: ViewModel

    // MARK: - Init

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    var body: some View {
        CCScreenWrapper(state: viewModel.screenState) {
            VStack(spacing: .zero) {
                navBar

                Spacer()
                    .frame(height: CCSpacing.lg)

                filterView

                if viewModel.exchanges.isEmpty {
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
                Text("HistorySearch.nav.title")
                    .font(CCFont.body)
                    .foregroundStyle(CCColor.labelPrimary.color)
            },
            right: {
                Button {
                    viewModel.handleInput(.onTapBackButton)
                } label: {
                    CCIcon.System.xmarkIcon.image
                        .font(CCFont.body)
                        .foregroundStyle(CCColor.labelPrimary.color)
                }
            }
        )
    }

    @ViewBuilder
    private var emptyView: some View {
        VStack {
            Spacer()

            CCEmptyView(
                icon: CCIcon.System.pencilListClipboardIcon.image,
                title: "HistorySearch.empty.title".localized(),
                message: "HistorySearch.empty.message".localized()
            )
            .padding(.horizontal, CCSpacing.lg)

            Spacer()
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: .zero) {
            exchangesList
                .padding(.horizontal, CCSpacing.lg)
        }
    }

    @ViewBuilder
    private var filterView: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                Text("HistorySearch.tip.title")
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
                    placeholder: "HistorySearch.button.initial.placeholder".localized(),
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
                    placeholder: "HistorySearch.button.result.placeholder".localized(),
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
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: .zero) {
                    ForEach(
                        Array(zip(viewModel.exchanges, viewModel.exchanges.indices)),
                        id: \.0.id
                    ) { exchange, index in
                        HistoryListItemView(exchange: exchange)
                            .if(index == .zero) {
                                $0.readOffset(in: .named("id:historyScroll")) { offset in
                                    showScrollToTopButton = offset < -50
                                }
                            }
                            .if(index == .zero) {
                                $0.id("id:firstHistoryItem")
                            }
                    }
                }
            }
            .background(.clear)
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            .safeAreaInset(edge: .bottom) {
                if showScrollToTopButton {
                    HStack(spacing: .zero) {
                        Spacer()

                        Button {
                            withAnimation {
                                proxy.scrollTo("id:firstHistoryItem", anchor: .top)
                            }
                        } label: {
                            CCIcon.System.arrowUpIcon.image
                                .font(CCFont.body)
                                .foregroundStyle(CCColor.labelPrimaryInvariably.color)
                                .frame(maxWidth: 40, maxHeight: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: CCCornerRadius.sm)
                                        .foregroundStyle(CCColor.accentBlue.color)
                                )
                        }
                    }
                    .padding(.bottom, CCSpacing.sm)
                }
            }
            .coordinateSpace(name: "id:historyScroll")
        }
    }
}
