import SwiftUI
import Combine
import UseCases
import Domain
import DesignSystem
import FlowStacks

// MARK: - HistoryViewModelInterface

protocol HistoryViewModelInterface: ObservableObject {
    var exchanges: [Exchange] { get }
    var screenState: CCScreenState { get }

    func handleInput(_ input: HistoryViewModelInput)
}

// MARK: - HistoryViewModelInput

enum HistoryViewModelInput {
    case onAppear
    case onTapRefreshButton
    case onAppearExchange(_ index: Int)
}

// MARK: - HistoryViewModel

final class HistoryViewModel {
    // MARK: - Internal Properties

    @Published var exchanges = [Exchange]()
    @Published var screenState = CCScreenState.pending

    // MARK: - Private Properties

    private var isLoadingExchanges = false

    private let historyUseCase: HistoryUseCaseInterface

    // MARK: - Init

    init(historyUseCase: HistoryUseCaseInterface) {
        self.historyUseCase = historyUseCase
    }

    // MARK: - Private Methods

    private func fetchHistory(isReloading: Bool = false) {
        isLoadingExchanges = true

        Task {
            let loadingTask = scheduleState(state: .loading, after: 2)

            switch await historyUseCase.fetchExchanges() {
            case let .success(exchanges):
                await MainActor.run {
                    if isReloading {
                        self.exchanges = exchanges
                    } else if !exchanges.isEmpty {
                        self.exchanges.append(
                            contentsOf: exchanges.filter { exchange in
                                !self.exchanges.contains(where: { $0.id == exchange.id })
                            }
                        )
                    }

                    if screenState != .pending {
                        screenState = .pending
                    }
                }

            case let .failure(error):
                await MainActor.run {
                    screenState = .error(error.message)
                    scheduleState(state: .pending, after: 4)
                }
            }

            loadingTask.cancel()
            isLoadingExchanges = false
        }
    }

    @discardableResult
    private func scheduleState(state: CCScreenState, after seconds: UInt64) -> Task<Void, Never> {
        Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: seconds * 1_000_000_000)
                self.screenState = state
            } catch {}
        }
    }
}

// MARK: - HistoryViewModelInterface

extension HistoryViewModel: HistoryViewModelInterface {
    func handleInput(_ input: HistoryViewModelInput) {
        switch input {
        case .onAppear:
            guard exchanges.isEmpty else { return }

            historyUseCase.resetPagination()
            fetchHistory()

        case .onTapRefreshButton:
            historyUseCase.resetPagination()
            fetchHistory(isReloading: true)

        case let .onAppearExchange(index):
            guard index == exchanges.indices.last, !isLoadingExchanges else { return }

            fetchHistory()
        }
    }
}
