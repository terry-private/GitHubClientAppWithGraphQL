import Foundation

struct TokenRepository {
    public var fetch: () -> String?
    public var update: (String) -> Void
    public var remove: () -> Void
}

extension TokenRepository {
    static let tokenKey: String = "token"
}

extension TokenRepository {
    static var forProduction = {
        let userDefaults = UserDefaults.standard
        return TokenRepository {
            userDefaults.string(forKey: TokenRepository.tokenKey)
        } update: { token in
            userDefaults.set(token, forKey: TokenRepository.tokenKey)
        } remove: {
            userDefaults.removeObject(forKey: TokenRepository.tokenKey)
        }
    }()
}
