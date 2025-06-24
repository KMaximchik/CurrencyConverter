import Foundation
import Core
import Network

// MARK: - CurrenciesEndpoint

enum CurrenciesEndpoint: NetworkEndpoint {
    case getCurrencies(currencies: String?)

    var baseURL: URL {
        URL(string: "https://api.freecurrencyapi.com/v1")!
    }

    var path: String {
        switch self {
        case .getCurrencies:
            "/currencies"
        }
    }

    var method: NetworkMethod {
        switch self {
        case .getCurrencies:
            return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getCurrencies:
            return [
                "apiKey": AppConfiguration.shared.apiKey
            ]
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .getCurrencies(currencies):
            guard let currencies else {
                return nil
            }

            return [
                "currencies": currencies
            ]
        }
    }
}
