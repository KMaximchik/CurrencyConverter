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
        sortDescriptors: [SortDescriptor<T>]
    ) async throws -> [T]
}

// MARK: - DatabaseClient

public final class DatabaseClient {

    // MARK: - Private

    private let context: ModelContext

    // MARK: - Init

    public init(context: ModelContext) {
        self.context = context
    }
}

// MARK: - DatabaseClientInterface

extension DatabaseClient: DatabaseClientInterface {
    public func save<T: PersistentModel>(_ object: T) async throws {
        context.insert(object)

        do {
            try context.save()
        } catch {
            throw DatabaseError.savingError(error)
        }
    }

    public func save<T: PersistentModel>(_ objects: [T]) async throws {
        objects.forEach {
            context.insert($0)
        }

        do {
            try context.save()
        } catch {
            throw DatabaseError.savingError(error)
        }
    }

    public func delete<T: PersistentModel>(_ object: T) async throws {
        context.delete(object)

        do {
            try context.save()
        } catch {
            throw DatabaseError.deletingError(error)
        }
    }

    public func deleteAll<T: PersistentModel>(of type: T.Type) async throws {
        let descriptor = FetchDescriptor<T>()

        do {
            let objects = try context.fetch(descriptor)

            objects.forEach {
                context.delete($0)
            }

            try context.save()
        } catch {
            throw DatabaseError.deletingError(error)
        }
    }

    public func fetch<T: PersistentModel>(
        predicate: Predicate<T>? = nil,
        sortDescriptors: [SortDescriptor<T>] = []
    ) async throws -> [T] {
        var descriptor = FetchDescriptor<T>(sortBy: sortDescriptors)
        descriptor.predicate = predicate

        do {
            return try context.fetch(descriptor)
        } catch {
            throw DatabaseError.fetchingError(error)
        }
    }
}
