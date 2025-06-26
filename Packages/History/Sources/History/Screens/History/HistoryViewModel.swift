import SwiftUI
import Combine
import UseCases
import Domain
import DesignSystem

// MARK: - HistoryViewModelInterface

protocol HistoryViewModelInterface: ObservableObject {
    var exchanges: [Exchange] { get }
    var screenState: CCScreenState { get }

    var outputPublisher: AnyPublisher<HistoryViewModelOutput, Never> { get }
    func handleInput(_ input: HistoryViewModelInput)
}

// MARK: - HistoryViewModelOutput

enum HistoryViewModelOutput {
    case goSearch
}

// MARK: - HistoryViewModelInput

enum HistoryViewModelInput {
    case onAppear
    case onTapSearchButton
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
    private var isViewLoaded = false
    private let outputSubject = PassthroughSubject<HistoryViewModelOutput, Never>()

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
                loadingTask.cancel()

                await MainActor.run {
                    if isReloading {
                        self.exchanges = exchanges
                    } else if !exchanges.isEmpty {
                        self.exchanges.append(contentsOf: exchanges)
                    }

                    if screenState != .pending {
                        screenState = .pending
                    }
                }

            case let .failure(error):
                loadingTask.cancel()

                await MainActor.run {
                    screenState = .error(error.message)
                    scheduleState(state: .pending, after: 4)
                }
            }

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
    var outputPublisher: AnyPublisher<HistoryViewModelOutput, Never> {
        outputSubject.eraseToAnyPublisher()
    }

    func handleInput(_ input: HistoryViewModelInput) {
        switch input {
        case .onAppear:
            guard !isViewLoaded || exchanges.isEmpty else { return }

            historyUseCase.resetPagination()
            fetchHistory()
            isViewLoaded = true

        case .onTapSearchButton:
            outputSubject.send(.goSearch)

        case .onTapRefreshButton:
            historyUseCase.resetPagination()
            fetchHistory(isReloading: true)

        case let .onAppearExchange(index):
            guard index == exchanges.indices.last, !isLoadingExchanges else { return }

            fetchHistory()
        }
    }
}
