import SwiftUI
import Combine

// MARK: - HistoryViewModelInterface

protocol HistoryViewModelInterface: ObservableObject {
    associatedtype Output
    var outputPublisher: AnyPublisher<Output, Never> { get }

    associatedtype Input
    func handleInput(_ input: Input)
}

// MARK: - HistoryViewModel

final class HistoryViewModel {
    // MARK: - Private Properties

    private let outputSubject = PassthroughSubject<Output, Never>()
}

// MARK: - HistoryViewModelInterface

extension HistoryViewModel: HistoryViewModelInterface {
    enum Output {}

    enum Input {}

    var outputPublisher: AnyPublisher<Output, Never> {
        outputSubject.eraseToAnyPublisher()
    }

    func handleInput(_ input: Input) {
        
    }
}
