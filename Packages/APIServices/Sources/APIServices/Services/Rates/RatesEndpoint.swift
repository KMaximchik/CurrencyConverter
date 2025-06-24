import Foundation
import Core
import Network

// MARK: - RatesEndpoint

enum RatesEndpoint: NetworkEndpoint {
    case getRates(baseCurrency: String?, currencies: String?)

    var baseURL: URL {
        URL(string: "https://api.freecurrencyapi.com/v1")!
    }

    var path: String {
        switch self {
        case .getRates:
            "/latest"
        }
    }

    var method: NetworkMethod {
        switch self {
        case .getRates:
            return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getRates:
            return [
                "apiKey": AppConfiguration.shared.apiKey
            ]
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .getRates(baseCurrency, currencies):
            var parameters = [String: Any]()

            if let baseCurrency {
                parameters["base_currency"] = baseCurrency
            }

            if let currencies {
                parameters["currencies"] = currencies
            }

            return parameters
        }
    }
}
