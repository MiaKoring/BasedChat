import Foundation

enum RealmError: Error {
    case thawFailed
    case deleteFailed
    case objectNotFound
    case idEmpty
}
