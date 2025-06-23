import Foundation

// MARK: - DatabaseError

public enum DatabaseError: Error {
    case savingError(Error)
    case deletingError(Error)
    case fetchingError(Error)
}
