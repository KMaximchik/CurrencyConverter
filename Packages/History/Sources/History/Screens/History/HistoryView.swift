import SwiftUI
import DesignSystem
import Utilities

// MARK: - HistoryView

struct HistoryView<ViewModel: HistoryViewModelInterface>: View {
    // MARK: - Private Properties

    @State private var showScrollToTopButton = false
    @State private var shouldScrollToTop = false

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
            left: {
                Button {
                    shouldScrollToTop = true
                    viewModel.handleInput(.onTapRefreshButton)
                } label: {
                    CCIcon.System.arrowClockwiseIcon.image
                        .font(CCFont.body)
                        .foregroundStyle(CCColor.labelPrimary.color)
                }
            },
            title: {
                Text("History.nav.title")
                    .font(CCFont.body)
                    .foregroundStyle(CCColor.labelPrimary.color)
            },
            right: {
                Button {
                    viewModel.handleInput(.onTapSearchButton)
                } label: {
                    CCIcon.System.magnifyingglassIcon.image
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
            exchangesList
                .padding(.horizontal, CCSpacing.lg)
        }
    }

    @ViewBuilder
    private var reloadTipView: some View {
        Group {
            Text("History.refresh.tip.title1")
            + Text(CCIcon.System.arrowClockwiseIcon.image)
            + Text("History.refresh.tip.title2")
        }
        .font(CCFont.caption)
        .foregroundStyle(CCColor.labelSecondary.color)
    }

    @ViewBuilder
    private var exchangesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                reloadTipView
                    .padding(.top, CCSpacing.sm)
                    .id("id:reloadTipView")
                    .readOffset(in: .named("id:historyScroll")) { offset in
                        withAnimation {
                            showScrollToTopButton = offset < -50
                        }
                    }

                LazyVStack(spacing: .zero) {
                    ForEach(
                        Array(zip(viewModel.exchanges, viewModel.exchanges.indices)),
                        id: \.0.id
                    ) { exchange, index in
                        HistoryListItemView(exchange: exchange)
                            .onAppear {
                                viewModel.handleInput(.onAppearExchange(index))
                            }
                    }
                }
            }
            .background(.clear)
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: .zero) {
                    Spacer()

                    Button {
                        withAnimation {
                            proxy.scrollTo("id:reloadTipView", anchor: .top)
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
                .opacity(showScrollToTopButton ? 1 : .zero)
            }
            .coordinateSpace(name: "id:historyScroll")
            .refreshable {
                viewModel.handleInput(.onTapRefreshButton)
            }
            .onChange(of: shouldScrollToTop) { _, newValue in
                guard newValue else {
                    return
                }

                withAnimation {
                    proxy.scrollTo("id:reloadTipView", anchor: .top)
                }

                self.shouldScrollToTop = false
            }
        }
    }
}
