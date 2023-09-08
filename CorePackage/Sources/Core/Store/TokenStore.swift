import Foundation

@MainActor
public class TokenStore {
    @Published public private(set) var token: String?
    public private(set) var refresh: () -> Void
    public private(set) var setToken: (String) -> Void
    
    private var client: TokenClient
    
    init(client: TokenClient) {
        self.client = client
        token = client.fetch()
        self.refresh = {}
        self.setToken = { _ in }
    }
}

// implements
extension TokenStore {
    // Repositoryは公開しない
    public static var forProduction: TokenStore = forProduction(.forProduction)
    
    // RepositoryをDIしてテストできる
    static func forProduction( _ client: TokenClient = .forProduction) -> TokenStore {
        let tokenStore = TokenStore(client: client)
        tokenStore.refresh = {
            tokenStore.token = nil
            tokenStore.client.remove()
        }
        tokenStore.setToken = { newToken in
            tokenStore.token = newToken
            tokenStore.client.update(newToken)
        }
        return tokenStore
    }
}
