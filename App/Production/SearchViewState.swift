import Foundation
import Combine
import Core
import Apollo

@MainActor
class SearchViewState: ObservableObject {
    @Published var isShowInputTokenView: Bool = false
    @Published var inputToken: String
    @Published var repositories: [Repository] = []
    @Published var searchWord: String = "swift"
    @Published var selectedCachePolicy: CachePolicy = .default
    
    private let tokenStore: TokenStore
    private var inMemoryClient: GraphQLClient
    private var sqliteClient: GraphQLClient
    private var cancellables: Set<AnyCancellable> = []
    
    init(tokenStore: TokenStore) {
        self.tokenStore = tokenStore
        let token = tokenStore.token ?? ""
        inputToken = token
        inMemoryClient = .inMemoryCacheClient(token: token)
        sqliteClient = .sqliteCacheClient(token: token)
        tokenStore.$token
            .sink { [weak self] token in
                self?.isShowInputTokenView = token == nil
            }
            .store(in: &cancellables)
    }
    
    func tokenSetButtonTapped() {
        tokenStore.setToken(inputToken)
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
        tokenStore.refresh()
    }
}
