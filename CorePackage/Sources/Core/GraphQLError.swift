import Foundation

public enum GraphQLError: Error {
    case translationFailed
    case unexpected
}

extension GraphQLError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .translationFailed: return "Translation failed"
        case .unexpected: return "Unknown error happened"
        }
    }
}
