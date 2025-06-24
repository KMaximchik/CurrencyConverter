import SwiftUI
import Combine
import UseCases
import Domain

// MARK: - ExchangeViewModelInterface

protocol ExchangeViewModelInterface: ObservableObject {
    var outputPublisher: AnyPublisher<ExchangeViewModelOutput, Never> { get }
    func handleInput(_ input: ExchangeViewModelInput)
}

// MARK: - ExchangeViewModelOutput

enum ExchangeViewModelOutput {}

// MARK: - ExchangeViewModelInput

enum ExchangeViewModelInput {
    case onAppear
}

// MARK: - ExchangeViewModel

final class ExchangeViewModel {
    // MARK: - Private Properties

    private let currenciesUseCases: CurrenciesUseCaseInterface

    private let outputSubject = PassthroughSubject<ExchangeViewModelOutput, Never>()

    // MARK: - Init

    init(currenciesUseCases: CurrenciesUseCaseInterface) {
        self.currenciesUseCases = currenciesUseCases
    }
}

// MARK: - ExchangeViewModelInterface

extension ExchangeViewModel: ExchangeViewModelInterface {
    var outputPublisher: AnyPublisher<ExchangeViewModelOutput, Never> {
        outputSubject.eraseToAnyPublisher()
    }

    func handleInput(_ input: ExchangeViewModelInput) {
        Task {
            let currencies = try? await currenciesUseCases.getCurrencies(currencies: CurrencyCode.allCases)
//            print(currencies)

            let rates = try? await currenciesUseCases.getRates(
                baseCurrency: .USD,
                currencies: CurrencyCode.allCases
            )
            print(rates)
        }
    }
}
