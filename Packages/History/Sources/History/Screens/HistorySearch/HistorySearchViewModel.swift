import SwiftUI
import Combine
import UseCases
import Domain
import DesignSystem

// MARK: - HistorySearchViewModelInterface

protocol HistorySearchViewModelInterface: ObservableObject {
    var exchanges: [Exchange] { get }
    var screenState: CCScreenState { get }
    var fromCurrencyCode: String? { get set }
    var toCurrencyCode: String? { get set }
    var searchButtonEnabled: Bool { get }
    var availableFromCurrencies: [CurrencyCode] { get }
    var availableToCurrencies: [CurrencyCode] { get }

    var outputPublisher: AnyPublisher<HistorySearchViewModelOutput, Never> { get }
    func handleInput(_ input: HistorySearchViewModelInput)
}

// MARK: - HistorySearchViewModelOutput

enum HistorySearchViewModelOutput {
    case goBack
}

// MARK: - HistorySearchViewModelInput

enum HistorySearchViewModelInput {
    case onAppear
    case onTapBackButton
    case onTapSwapButton
    case onTapSearchButton
    case onTapResetButton
}

// MARK: - HistorySearchViewModel

final class HistorySearchViewModel {
    // MARK: - Internal Properties

    @Published var exchanges = [Exchange]()
    @Published var screenState = CCScreenState.pending
    @Published var fromCurrencyCode: String?
    @Published var toCurrencyCode: String?
    @Published var searchButtonEnabled = true
    @Published var availableFromCurrencies = CurrencyCode.allCases
    @Published var availableToCurrencies = CurrencyCode.allCases

    // MARK: - Private Properties

    private let historyUseCase: HistoryUseCaseInterface

    private let outputSubject = PassthroughSubject<HistorySearchViewModelOutput, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(historyUseCase: HistoryUseCaseInterface) {
        self.historyUseCase = historyUseCase

        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
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

    private func swapSelectedCurrencies() {
        let tempCurrencyCode = fromCurrencyCode
        fromCurrencyCode = toCurrencyCode
        toCurrencyCode = tempCurrencyCode
    }

    private func searchExchanges() {
        guard let fromCurrencyCode, let toCurrencyCode else { return }

        Task {
            let loadingTask = scheduleState(state: .loading, after: 2)

            switch await historyUseCase.searchExchanges(
                fromCurrencyCode: fromCurrencyCode,
                toCurrencyCode: toCurrencyCode
            ) {
            case let .success(exchanges):
                loadingTask.cancel()

                await MainActor.run {
                    self.exchanges = exchanges

                    if screenState != .pending {
                        screenState = .pending
                    }
                }

            case .failure:
                loadingTask.cancel()
            }
        }
    }

    private func resetExchanges() {
        fromCurrencyCode = nil
        toCurrencyCode = nil
        exchanges.removeAll()
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

// MARK: - HistorySearchViewModelInterface

extension HistorySearchViewModel: HistorySearchViewModelInterface {
    var outputPublisher: AnyPublisher<HistorySearchViewModelOutput, Never> {
        outputSubject.eraseToAnyPublisher()
    }

    func handleInput(_ input: HistorySearchViewModelInput) {
        switch input {
        case .onAppear:
            break

        case .onTapBackButton:
            outputSubject.send(.goBack)

        case .onTapSwapButton:
            swapSelectedCurrencies()

        case .onTapSearchButton:
            searchExchanges()

        case .onTapResetButton:
            resetExchanges()
        }
    }
}
