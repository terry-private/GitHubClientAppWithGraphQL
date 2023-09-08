import Foundation

struct TokenClient {
    public var fetch: () -> String?
    public var update: (String) -> Void
    public var remove: () -> Void
}

extension TokenClient {
    static let tokenKey: String = "token"
}

// implements
extension TokenClient {
    static var forProduction = {
        let userDefaults = UserDefaults.standard
        return TokenClient {
            userDefaults.string(forKey: TokenClient.tokenKey)
        } update: { token in
            userDefaults.set(token, forKey: TokenClient.tokenKey)
        } remove: {
            userDefaults.removeObject(forKey: TokenClient.tokenKey)
        }
    }()
}
