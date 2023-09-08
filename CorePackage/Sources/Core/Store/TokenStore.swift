import Foundation

@MainActor
public class TokenStore {
    @Published public private(set) var token: String?
    public private(set) var refresh: () -> Void
    public private(set) var setToken: (String) -> Void
    
    var repository: TokenRepository
    
    init(repository: TokenRepository) {
        self.repository = repository
        token = repository.fetch()
        self.refresh = {}
        self.setToken = { _ in }
    }
}

// implements
extension TokenStore {
    // Repositoryは公開しない
    public static var forProduction: TokenStore = forProduction(.forProduction)
    
    // RepositoryをDIしてテストできる
    static func forProduction( _ repository: TokenRepository = .forProduction) -> TokenStore {
        let tokenStore = TokenStore(repository: repository)
        tokenStore.refresh = {
            tokenStore.token = nil
            tokenStore.repository.remove()
        }
        tokenStore.setToken = { newToken in
            tokenStore.token = newToken
            tokenStore.repository.update(newToken)
        }
        return tokenStore
    }
}
