import SwiftUI
import Combine
import UseCases
import Domain
import DesignSystem

// MARK: - HistoryViewModelInterface

protocol HistoryViewModelInterface: ObservableObject {
    var exchanges: [Exchange] { get }
    var filteredExchanges: [Exchange] { get }
    var screenState: CCScreenState { get }
    var fromCurrencyCode: String? { get set }
    var toCurrencyCode: String? { get set }
    var availableFromCurrencies: [CurrencyCode] { get }
    var availableToCurrencies: [CurrencyCode] { get }
    var searchButtonEnabled: Bool { get }

    var outputPublisher: AnyPublisher<HistoryViewModelOutput, Never> { get }
    func handleInput(_ input: HistoryViewModelInput)
}

// MARK: - HistoryViewModelOutput

enum HistoryViewModelOutput {}

// MARK: - HistoryViewModelInput

enum HistoryViewModelInput {
    case onAppear
    case onTapSearchButton
    case onTapResetButton
}

// MARK: - HistoryViewModel

final class HistoryViewModel {
    // MARK: - Internal Properties

    @Published var exchanges = [Exchange]()
    @Published var filteredExchanges = [Exchange]()
    @Published var screenState = CCScreenState.pending
    @Published var fromCurrencyCode: String?
    @Published var toCurrencyCode: String?
    @Published var availableFromCurrencies = CurrencyCode.allCases
    @Published var availableToCurrencies = CurrencyCode.allCases
    @Published var searchButtonEnabled = true

    // MARK: - Private Properties

    private let historyUseCase: HistoryUseCaseInterface

    private let outputSubject = PassthroughSubject<HistoryViewModelOutput, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(historyUseCase: HistoryUseCaseInterface) {
        self.historyUseCase = historyUseCase

        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        $exchanges
            .receive(on: RunLoop.main)
            .map { value in
                value
            }
            .assign(to: &$filteredExchanges)

        $fromCurrencyCode
            .receive(on: RunLoop.main)
            .map { value in
                guard let value else { return CurrencyCode.allCases }

                return CurrencyCode.allCases.filter { $0.rawValue != value }
            }
            .assign(to: &$availableToCurrencies)

        $toCurrencyCode
            .receive(on: RunLoop.main)
            .map { value in
                guard let value else { return CurrencyCode.allCases }

                return CurrencyCode.allCases.filter { $0.rawValue != value }
            }
            .assign(to: &$availableFromCurrencies)

        Publishers.CombineLatest($toCurrencyCode, $fromCurrencyCode)
            .receive(on: RunLoop.main)
            .map { toCurrencyCode, fromCurrencyCode in
                toCurrencyCode != nil && fromCurrencyCode != nil
            }
            .assign(to: &$searchButtonEnabled)
    }

    private func fetchHistory() {
        Task {
            let loadingTask = scheduleState(state: .loading, after: 2)

            switch await historyUseCase.fetchExchanges() {
            case let .success(exchanges):
                loadingTask.cancel()

                await MainActor.run {
                    self.exchanges = exchanges
                    screenState = .pending
                }

            case let .failure(error):
                loadingTask.cancel()

                await MainActor.run {
                    screenState = .error(error.message)
                    scheduleState(state: .pending, after: 4)
                }
            }
        }
    }

    private func searchExchanges() {
        guard let fromCurrencyCode, let toCurrencyCode else {
            filteredExchanges = exchanges

            return
        }

        filteredExchanges = historyUseCase.searchExchanges(
            from: exchanges,
            fromCurrencyCode: fromCurrencyCode,
            toCurrencyCode: toCurrencyCode
        )
    }

    private func resetExchanges() {
        fromCurrencyCode = nil
        toCurrencyCode = nil
        filteredExchanges = exchanges
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
            guard fromCurrencyCode == nil, toCurrencyCode == nil else { return }
            
            fetchHistory()

        case .onTapSearchButton:
            searchExchanges()

        case .onTapResetButton:
            resetExchanges()
        }
    }
}
