import Foundation
import Core
import Apollo

@MainActor
class SearchViewState: ObservableObject {
    @Published var isShowInputTokenView: Bool = false
    @Published var inMemoryClient: GraphQLClient
    @Published var sqliteClient: GraphQLClient
    @Published var inputToken: String
    @Published var repositories: [Repository] = []
    @Published var searchWord: String = "swift"
    @Published var selectedCachePolicy: CachePolicy = .default
    
    init() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        inputToken = token
        isShowInputTokenView = token == ""
        inMemoryClient = .inMemoryCacheClient(token: token)
        sqliteClient = .sqliteCacheClient(token: token)
    }
    
    func tokenSetButtonTapped() {
        UserDefaults.standard.set(inputToken, forKey: "token")
        isShowInputTokenView = false
        inMemoryClient = .inMemoryCacheClient(token: inputToken)
        sqliteClient = .sqliteCacheClient(token: inputToken)
    }
    
    // MARK: - InMemoryClient
    func inMemoryClientFetchButtonTapped() {
        Task {
            do {
                repositories = try await inMemoryClient.searchRepositories(word: searchWord, cachePolicy: selectedCachePolicy)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func inMemoryClientReadCacheButtonTapped() {
        Task {
            do {
                repositories = try await inMemoryClient.searchRepositoriesFromCache(word: searchWord)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func inMemoryClientClearCacheButtonTapped() {
        inMemoryClient.clearCache()
    }
        
    // MARK: - SQLiteMemoryClient
    func sqliteClientFetchButtonTapped() {
        Task {                                do {
                repositories = try await sqliteClient.searchRepositories(word: searchWord, cachePolicy: selectedCachePolicy)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func sqliteClientReadCacheButtonTapped() {
        Task {
            do {
                repositories = try await sqliteClient.searchRepositoriesFromCache(word: searchWord)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func sqliteClientClearCacheButtonTapped() {
        sqliteClient.clearCache()
    }
    
    // MARK: - Action For List
    func clearListButtonTapped() {
        repositories.removeAll()
    }
    
    func resetTokenButtonTapped() {
        UserDefaults.standard.set("", forKey: "token")
        isShowInputTokenView = true
    }
}
