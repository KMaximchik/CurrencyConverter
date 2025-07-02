import SwiftData
import Foundation
import UseCases
import DBServices
import APIServices
import StorageServices
import Network
import Database
import Entities

// MARK: - AppAssemblyInterface

protocol AppAssemblyInterface {
    var useCasesAssembly: UseCasesAssemblyInterface { get }
}

// MARK: - AppAssembly

final class AppAssembly: AppAssemblyInterface {
    // MARK: - Internal Properties

    let useCasesAssembly: UseCasesAssemblyInterface

    // MARK: - Init

    init() {
        let container = try! ModelContainer(for: RateEntity.self, ExchangeEntity.self)
        let databaseClient = DatabaseClient(container: container)
        let dbServicesAssembly = DBServicesAssembly(databaseClient: databaseClient)

        let urlSession = URLSession.shared
        let apiServicesAssembly = APIServicesAssembly(
            networkClient: NetworkClient(apiKey: AppConfiguration.shared.apiKey, session: urlSession)
        )

        let userDefaults = UserDefaults.standard
        let storageServicesAssembly = StorageServicesAssembly(userDefaults: userDefaults)

        let useCasesAssembly = UseCasesAssembly(
            dbServicesAssembly: dbServicesAssembly,
            apiServicesAssembly: apiServicesAssembly,
            storageServicesAssembly: storageServicesAssembly
        )

        self.useCasesAssembly = useCasesAssembly
    }
}
