import SwiftUI
import Combine
import UseCases
import Domain
import DesignSystem

// MARK: - ExchangeViewModelInterface

protocol ExchangeViewModelInterface: ObservableObject {
    var screenState: CCScreenState { get }
    var fromCurrencyCode: String? { get set }
    var toCurrencyCode: String? { get set }
    var fromValue: Decimal { get set }
    var toValue: Decimal { get set }
    var caption: String? { get }
    var maximumFractionDigits: Int { get }
    var availableFromCurrencies: [CurrencyCode] { get }
    var availableToCurrencies: [CurrencyCode] { get }
    var defaultInputsValue: Decimal { get }

    var outputPublisher: AnyPublisher<ExchangeViewModelOutput, Never> { get }
    func handleInput(_ input: ExchangeViewModelInput)
}

// MARK: - ExchangeViewModelOutput

enum ExchangeViewModelOutput {}

// MARK: - ExchangeViewModelInput

enum ExchangeViewModelInput {
    case onAppear
    case onTapSwapButton
}

// MARK: - ExchangeViewModel

final class ExchangeViewModel {
    // MARK: - Internal Properties

    @Published var screenState = CCScreenState.pending
    @Published var fromCurrencyCode: String?
    @Published var toCurrencyCode: String?
    @Published var fromValue = Decimal.zero
    @Published var toValue = Decimal.zero
    @Published var caption: String?
    @Published var availableFromCurrencies = CurrencyCode.allCases
    @Published var availableToCurrencies = CurrencyCode.allCases

    var maximumFractionDigits: Int = 2
    var defaultInputsValue: Decimal = 1

    // MARK: - Private Properties

    @Published private var actualRate: Rate?

    private let currenciesUseCase: CurrenciesUseCaseInterface
    private let historyUseCase: HistoryUseCaseInterface

    private let outputSubject = PassthroughSubject<ExchangeViewModelOutput, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(
        currenciesUseCase: CurrenciesUseCaseInterface,
        historyUseCase: HistoryUseCaseInterface
    ) {
        self.currenciesUseCase = currenciesUseCase
        self.historyUseCase = historyUseCase

        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        $fromValue
            .debounce(for: .seconds(1.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                guard
                    let fromCurrencyCode = self?.fromCurrencyCode,
                    let toCurrencyCode = self?.toCurrencyCode
                else { return }

                self?.getActualRate(
                    fromCurrencyCode: fromCurrencyCode,
                    toCurrencyCode: toCurrencyCode
                )
            }
            .store(in: &cancellables)

        $fromCurrencyCode
            .compactMap { $0 }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.availableToCurrencies = CurrencyCode.allCases.filter { $0.rawValue != value }

                guard let toCurrencyCode = self?.toCurrencyCode else { return }

                self?.getActualRate(
                    fromCurrencyCode: value,
                    toCurrencyCode: toCurrencyCode
                )
                self?.saveCurrencyPair(fromCurrencyCode: value, toCurrencyCode: toCurrencyCode)
            }
            .store(in: &cancellables)

        $toCurrencyCode
            .compactMap { $0 }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.availableFromCurrencies = CurrencyCode.allCases.filter { $0.rawValue != value }

                guard let fromCurrencyCode = self?.fromCurrencyCode else { return }

                self?.getActualRate(
                    fromCurrencyCode: fromCurrencyCode,
                    toCurrencyCode: value
                )
                self?.saveCurrencyPair(fromCurrencyCode: fromCurrencyCode, toCurrencyCode: value)
            }
            .store(in: &cancellables)

        $actualRate
            .receive(on: RunLoop.main)
            .sink { [weak self] rate in
                guard
                    let rate,
                    let fromValue = self?.fromValue,
                    let fromCurrencyCode = self?.fromCurrencyCode,
                    let toCurrencyCode = self?.toCurrencyCode
                else { return }

                self?.caption = self?.makeCaption(
                    fromCurrencyCode: self?.fromCurrencyCode,
                    toCurrencyCode: self?.toCurrencyCode,
                    rateValue: rate.value
                )

                guard fromValue > .zero else {
                    self?.toValue = .zero
                    return
                }

                guard
                    let calculatedValue = self?.currenciesUseCase.calculate(value: fromValue, rate: rate)
                else { return }

                self?.toValue = calculatedValue
                self?.saveExchange(
                    fromCurrencyCode: fromCurrencyCode,
                    toCurrencyCode: toCurrencyCode,
                    value: calculatedValue,
                    initialValue: fromValue,
                    rateValue: rate.value
                )
            }
            .store(in: &cancellables)
    }

    private func getActualRate(fromCurrencyCode: String, toCurrencyCode: String) {
        guard
            let fromCurrencyCode = CurrencyCode(rawValue: fromCurrencyCode),
            let toCurrencyCode = CurrencyCode(rawValue: toCurrencyCode)
        else { return }

        Task {
            let loadingTask = scheduleState(state: .loading, after: 2)

            switch await currenciesUseCase.getRate(
                baseCurrency: fromCurrencyCode,
                toCurrency: toCurrencyCode
            ) {
            case let .success(rate):
                loadingTask.cancel()

                await MainActor.run {
                    actualRate = rate

                    caption = makeCaption(
                        fromCurrencyCode: fromCurrencyCode.rawValue,
                        toCurrencyCode: toCurrencyCode.rawValue,
                        rateValue: rate?.value
                    )

                    screenState = .pending
                }

            case let .failure(error):
                loadingTask.cancel()

                await MainActor.run {
                    caption = nil
                    screenState = .error(error.message)
                    scheduleState(state: .pending, after: 4)
                }
            }
        }
    }

    private func makeCaption(fromCurrencyCode: String?, toCurrencyCode: String?, rateValue: Decimal?) -> String? {
        guard
            let fromCurrencyCode,
            let toCurrencyCode,
            let rateValue,
            let rateValueString = rateValue.toString()
        else { return nil }

        return String(
            format: "Exchange.caption".localized(),
            "\(fromCurrencyCode)",
            rateValueString,
            "\(toCurrencyCode)"
        )
    }

    private func setupInitialCurrencyPair() {
        guard fromCurrencyCode == nil && toCurrencyCode == nil else { return }

        let currencyPair = currenciesUseCase.getSavedCurrencyPair()

        fromCurrencyCode = currencyPair?.fromCurrencyCode
        toCurrencyCode = currencyPair?.toCurrencyCode
    }

    private func saveCurrencyPair(fromCurrencyCode: String, toCurrencyCode: String) {
        currenciesUseCase.saveCurrencyPair(fromCurrencyCode: fromCurrencyCode, toCurrencyCode: toCurrencyCode)
    }

    private func saveExchange(
        fromCurrencyCode: String,
        toCurrencyCode: String,
        value: Decimal,
        initialValue: Decimal,
        rateValue: Decimal
    ) {
        Task {
            switch await historyUseCase.saveExchange(
                fromCurrencyCode: fromCurrencyCode,
                toCurrencyCode: toCurrencyCode,
                value: value,
                initialValue: initialValue,
                rateValue: rateValue
            ) {
            case .success:
                break

            case let .failure(error):
                await MainActor.run {
                    screenState = .error(error.message)
                    scheduleState(state: .pending, after: 4)
                }
            }
        }
    }

    private func swapSelectedCurrencies() {
        let tempCurrencyCode = fromCurrencyCode
        fromCurrencyCode = toCurrencyCode
        toCurrencyCode = tempCurrencyCode

        let tempValue = fromValue
        fromValue = toValue
        toValue = tempValue
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

// MARK: - ExchangeViewModelInterface

extension ExchangeViewModel: ExchangeViewModelInterface {
    var outputPublisher: AnyPublisher<ExchangeViewModelOutput, Never> {
        outputSubject.eraseToAnyPublisher()
    }

    func handleInput(_ input: ExchangeViewModelInput) {
        switch input {
        case .onAppear:
            setupInitialCurrencyPair()

        case .onTapSwapButton:
            swapSelectedCurrencies()
        }
    }
}
