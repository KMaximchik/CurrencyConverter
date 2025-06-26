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
        fromCurrencyCode: String,
        toCurrencyCode: String
    ) async -> Result<[Exchange], AppError>
    func resetPagination()
}

// MARK: - HistoryUseCase

final class HistoryUseCase {
    // MARK: - Private Properties

    private var currentPage = Int.zero
    private let fetchLimit = 20

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
            let exchanges = try await exchangesDBService.fetchExchanges(page: currentPage, fetchLimit: fetchLimit)

            currentPage += 1

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
        fromCurrencyCode: String,
        toCurrencyCode: String
    ) async -> Result<[Exchange], AppError> {
        do {
            let exchanges = try await exchangesDBService.fetchExchanges(
                by: fromCurrencyCode,
                toCurrencyCode: toCurrencyCode
            )

            return .success(exchanges)
        } catch {
            return .failure(AppError(from: error))
        }
    }

    func resetPagination() {
        currentPage = .zero
    }
}
