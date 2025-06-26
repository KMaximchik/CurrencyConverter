import SwiftData
import Foundation

// MARK: - DatabaseClientInterface

public protocol DatabaseClientInterface {
    func save<T: PersistentModel>(_ object: T) async throws
    func save<T: PersistentModel>(_ objects: [T]) async throws
    func delete<T: PersistentModel>(_ object: T) async throws
    func deleteAll<T: PersistentModel>(of type: T.Type) async throws
    func fetch<T: PersistentModel>(
        predicate: Predicate<T>?,
        sortDescriptors: [SortDescriptor<T>],
        fetchOffset: Int?,
        fetchLimit: Int?
    ) async throws -> [T]
}

// MARK: - DatabaseClient

public final class DatabaseClient {
    // MARK: - Private Properties

    private let container: ModelContainer

    // MARK: - Init

    public init(container: ModelContainer) {
        self.container = container
    }

    // MARK: - Private Methods

    private func performBackground<T>(
        _ action: @escaping (ModelContext) throws -> T
    ) async throws -> T {
        let context = ModelContext(container)

        return try await Task.detached(priority: .background) {
            do {
                return try action(context)
            } catch {
                throw error
            }
        }
        .value
    }
}

// MARK: - DatabaseClientInterface

extension DatabaseClient: DatabaseClientInterface {
    public func save<T: PersistentModel>(_ object: T) async throws {
        do {
            try await performBackground { context in
                context.insert(object)
                try context.save()
            }
        } catch {
            throw DatabaseError.savingError(error)
        }
    }

    public func save<T: PersistentModel>(_ objects: [T]) async throws {
        do {
            try await performBackground { context in
                objects.forEach { context.insert($0) }
                try context.save()
            }
        } catch {
            throw DatabaseError.savingError(error)
        }
    }

    public func delete<T: PersistentModel>(_ object: T) async throws {
        do {
            try await performBackground { context in
                context.delete(object)
                try context.save()
            }
        } catch {
            throw DatabaseError.deletingError(error)
        }
    }

    public func deleteAll<T: PersistentModel>(of type: T.Type) async throws {
        do {
            try await performBackground { context in
                let descriptor = FetchDescriptor<T>()
                let items = try context.fetch(descriptor)
                items.forEach { context.delete($0) }
                try context.save()
            }
        } catch {
            throw DatabaseError.deletingError(error)
        }
    }

    public func fetch<T: PersistentModel>(
        predicate: Predicate<T>?,
        sortDescriptors: [SortDescriptor<T>],
        fetchOffset: Int?,
        fetchLimit: Int?
    ) async throws -> [T] {
        do {
            return try await performBackground { context in
                var descriptor = FetchDescriptor<T>(sortBy: sortDescriptors)
                descriptor.predicate = predicate
                descriptor.fetchLimit = fetchLimit
                descriptor.fetchOffset = fetchOffset
                return try context.fetch(descriptor)
            }
        } catch {
            throw DatabaseError.fetchingError(error)
        }
    }
}
