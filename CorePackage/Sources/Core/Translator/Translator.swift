import GitHubSchema
import Foundation

protocol Translator {
    associatedtype Model
    func toModel() throws -> Model
}

public enum TranslateError: Error {
    case null
    case unexpected
}

extension TranslateError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .null: return "cannot translate to nonNull from null"
        case .unexpected: return "unknown error happened"
        }
    }
}
