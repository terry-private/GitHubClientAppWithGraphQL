import Foundation
import Apollo
import GitHubSchema
import ApolloSQLite

public struct GraphQLClient {
    static let baseURL: URL = .init(string: "https://api.github.com/graphql")!
    
    var apollo: ApolloClient
    
    public static func inMemoryCacheClient(token: String) -> Self {
        .init(token: token, cache: InMemoryNormalizedCache())
    }
    
    public static func sqliteCacheClient(token: String) -> Self {
        let documentsPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        ).first!
        let documentsURL = URL(fileURLWithPath: documentsPath)
        let sqliteFileURL = documentsURL.appendingPathComponent("apollo_db.sqlite")
        let sqliteCache = try! SQLiteNormalizedCache(fileURL: sqliteFileURL)
        return .init(token: token, cache: sqliteCache)
    }
    
    init(token: String, cache: some NormalizedCache) {
        let store = ApolloStore(cache: cache)
        let client = URLSessionClient()
        let provider = DefaultInterceptorProvider(client: client, store: store)
        let transport = RequestChainNetworkTransport(
            interceptorProvider: provider,
            endpointURL: GraphQLClient.baseURL,
            additionalHeaders: ["Authorization": "Bearer \(token)"]
        )
        apollo = ApolloClient(networkTransport: transport, store: store)
    }
    
    public func searchRepositories(word: String, cachePolicy: CachePolicy = .default) async throws -> [SeachedRepository] {
        let query = SearchRepositoriesQuery(query: .init(word), after: nil)
        return try await apollo.fetch(query: query, cachePolicy: cachePolicy)
    }
    
    public func searchRepositoriesFromCache(word: String, afterCursol: String? = nil) async throws -> [SeachedRepository] {
        let query = SearchRepositoriesQuery(query: .init(word), after: .init(afterCursol))
        return try await apollo.store.withinReadTransaction(query)
    }
    
    public func getRepository(name: String, owner: String) async throws -> DetailedRepository {
        let query = GetRepositoryQuery(name: name, owner: owner)
        return try await apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData)
    }
    
    public func getRepositoryFromCache(name: String, owner: String) async throws -> DetailedRepository {
        let query = GetRepositoryQuery(name: name, owner: owner)
        return try await apollo.store.withinReadTransaction(query)
    }
    
    public func clearCache() {
        apollo.clearCache()
    }
}
