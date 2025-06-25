import Foundation
import Domain
import DBServices
import Core

// MARK: - HistoryUseCaseInterface

public protocol HistoryUseCaseInterface {
    func fetchExchanges() async -> Result<[Exchange], AppError>
    func saveExchange(
        fromCurrencyCode: String,
        toCurrencyCode: String,
        value: Decimal,
        initialValue: Decimal,
        rateValue: Decimal
    ) async -> Result<UUID, AppError>
    func searchExchanges(
        from initialExchanges: [Exchange],
        fromCurrencyCode: String,
        toCurrencyCode: String
    ) -> [Exchange]
}

// MARK: - HistoryUseCase

final class HistoryUseCase {
    // MARK: - Private Properties

    private let exchangesDBService: ExchangesDBServiceInterface

    // MARK: - Init

    init(
        exchangesDBService: ExchangesDBServiceInterface
    ) {
        self.exchangesDBService = exchangesDBService
    }
}

// MARK: - HistoryUseCaseInterface

extension HistoryUseCase: HistoryUseCaseInterface {
    func fetchExchanges() async -> Result<[Exchange], AppError> {
        do {
            let exchanges = try await exchangesDBService.fetchExchanges()

            return .success(exchanges)
        } catch {
            return .failure(AppError(from: error))
        }
    }

    @discardableResult
    func saveExchange(
        fromCurrencyCode: String,
        toCurrencyCode: String,
        value: Decimal,
        initialValue: Decimal,
        rateValue: Decimal
    ) async -> Result<UUID, AppError> {
        do {
            let exchange = Exchange(
                id: UUID(),
                fromCurrencyCode: fromCurrencyCode,
                toCurrencyCode: toCurrencyCode,
                value: value,
                initialValue: initialValue,
                rateValue: rateValue,
                createdAt: Date.now
            )

            try await exchangesDBService.saveExchange(exchange)

            return .success(exchange.id)
        } catch {
            return .failure(AppError(from: error))
        }
    }

    func searchExchanges(
        from initialExchanges: [Exchange],
        fromCurrencyCode: String,
        toCurrencyCode: String
    ) -> [Exchange] {
        initialExchanges.filter {
            $0.fromCurrencyCode == fromCurrencyCode && $0.toCurrencyCode == toCurrencyCode
        }
    }
}
