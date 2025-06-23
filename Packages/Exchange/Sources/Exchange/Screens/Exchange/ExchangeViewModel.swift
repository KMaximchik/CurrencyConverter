import SwiftUI
import Combine

// MARK: - ExchangeViewModelInterface

protocol ExchangeViewModelInterface: ObservableObject {
    associatedtype Output
    var outputPublisher: AnyPublisher<Output, Never> { get }

    associatedtype Input
    func handleInput(_ input: Input)
}

// MARK: - ExchangeViewModel

final class ExchangeViewModel {
    // MARK: - Private Properties

    private let outputSubject = PassthroughSubject<Output, Never>()
}

// MARK: - ExchangeViewModelInterface

extension ExchangeViewModel: ExchangeViewModelInterface {
    enum Output {}

    enum Input {}

    var outputPublisher: AnyPublisher<Output, Never> {
        outputSubject.eraseToAnyPublisher()
    }

    func handleInput(_ input: Input) {

    }
}
