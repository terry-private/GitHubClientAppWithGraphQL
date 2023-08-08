import Foundation
import Apollo
import GitHubSchema

public struct GraphQLClient {
    static let baseURL: URL = .init(string: "https://api.github.com/graphql")!
    
    var apollo: ApolloClient = {
        Self.makeApolloClient()
    }()
    
    public static let shared = GraphQLClient()
    
    static func makeApolloClient() -> ApolloClient {
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let client = URLSessionClient()
        let provider = DefaultInterceptorProvider(client: client, store: store)
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let transport = RequestChainNetworkTransport(
            interceptorProvider: provider,
            endpointURL: baseURL,
            additionalHeaders: ["Authorization": "Bearer \(token)"]
        )
        return ApolloClient(networkTransport: transport, store: store)
    }
    
    public mutating func setToken(token: String) {
        UserDefaults.standard.set(token, forKey: "token")
        apollo = Self.makeApolloClient()
    }
    
    public func getRepository(owner: String, name: String) async throws -> GetRepositoryQuery.Data? {
        let query = GetRepositoryQuery(owner: owner, name: name)
        return try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: query) { result in
                switch result {
                case .success(let graphQLResult):
                    continuation.resume(returning: graphQLResult.data)
                case .failure(let error):
                    print(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
