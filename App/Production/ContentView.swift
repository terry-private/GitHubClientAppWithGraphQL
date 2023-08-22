import SwiftUI
import Core
import Apollo

struct ContentView: View {
    @AppStorage("token") var token = ""
    
    @State var inMemoryClient: GraphQLClient?
    @State var sqliteClient: GraphQLClient?
    @State var inputToken: String = UserDefaults.standard.string(forKey: "token") ?? ""
    @State var repositories: [Repository] = []
    @State var searchWord: String = "swift"
    @State var selectedCachePolicy: CachePolicy = .default
    
    init() {
        guard token != "" else { return }
        _inMemoryClient = .init(wrappedValue: .inMemoryCacheClient(token: token))
        _sqliteClient = .init(wrappedValue: .sqliteCacheClient(token: token))
    }
    
    var body: some View {
        VStack {
            if token == "" {
                SecureField("GitHub tokenを入力", text: $inputToken)
                Button {
                    token = inputToken
                    inMemoryClient = .inMemoryCacheClient(token: token)
                    sqliteClient = .sqliteCacheClient(token: token)
                } label: {
                    Text("set!!")
                        .padding(4)
                }
            } else {
                TextField("検索ワード", text: $searchWord)
                    .padding()
                    .background(Color.gray.cornerRadius(10).opacity(0.2))
                
                Picker("cachePolicy", selection: $selectedCachePolicy) {
                    ForEach(CachePolicy.allCases, id: \.self.title) { cachePolicy in
                        Text(cachePolicy.title).tag(cachePolicy)
                    }
                }
                Text(selectedCachePolicy.description)
                
                HStack {
                    VStack {
                        Text("メモリキャッシュ")
                        Button {
                            Task {
                                guard let inMemoryClient else { return }
                                do {
                                    repositories = try await inMemoryClient.searchRepositories(word: searchWord, cachePolicy: selectedCachePolicy)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        } label: {
                            Text("fetch")
                                .padding(4)
                        }
                        Button {
                            Task {
                                guard let inMemoryClient else { return }
                                do {
                                    repositories = try await inMemoryClient.searchRepositoriesFromCache(word: searchWord)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        } label: {
                            Text("read cache")
                                .padding(4)
                        }
                        Button {
                            inMemoryClient?.clearCache()
                        } label: {
                            Text("clear cache")
                                .padding(4)
                        }
                    }
                    .padding()
                    
                    VStack {
                        Text("SQLiteキャッシュ")
                        Button {
                            Task {
                                guard let sqliteClient else { return }
                                do {
                                    repositories = try await sqliteClient.searchRepositories(word: searchWord, cachePolicy: selectedCachePolicy)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        } label: {
                            Text("fetch")
                                .padding(4)
                        }
                        Button {
                            Task {
                                guard let sqliteClient else { return }
                                do {
                                    repositories = try await sqliteClient.searchRepositoriesFromCache(word: searchWord)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        } label: {
                            Text("read cache")
                                .padding(4)
                        }
                        Button {
                            sqliteClient?.clearCache()
                        } label: {
                            Text("clear cache")
                                .padding(4)
                        }
                    }
                    .padding()
                }
                
                Button {
                    repositories.removeAll()
                } label: {
                    Text("clear list")
                }
                
                List {
                    ForEach(repositories, id: \.self.id) { repository in
                        VStack {
                            Text(repository.owner.name ?? "")
                            Text("\(repository.name)")
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background {
                            Color.cyan
                                .cornerRadius(10)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                
                Button {
                    token = ""
                } label: {
                    Text("reset token")
                }
            }
        }
        .padding()
    }
}

extension CachePolicy: CaseIterable {
    public static var allCases: [Self] {
        [
           .returnCacheDataElseFetch,
           .fetchIgnoringCacheData,
           .fetchIgnoringCacheCompletely,
           .returnCacheDataDontFetch,
           .returnCacheDataAndFetch
       ]
    }
    
    var title: String {
        switch self {
        case .returnCacheDataElseFetch: return "returnCacheDataElseFetch"
        case .fetchIgnoringCacheData: return "fetchIgnoringCacheData"
        case .fetchIgnoringCacheCompletely: return "fetchIgnoringCacheCompletely"
        case .returnCacheDataDontFetch: return "returnCacheDataDontFetch"
        case .returnCacheDataAndFetch: return "returnCacheDataAndFetch"
        }
    }
    
    var description: String {
        switch self {
        case .returnCacheDataElseFetch:
            return "利用可能であればキャッシュからデータを返し、そうでなければサーバーから結果をフェッチする。(Default)"
        case .fetchIgnoringCacheData:
            return "常にサーバから結果をフェッチする。"
        case .fetchIgnoringCacheCompletely:
            return "結果を常にサーバからフェッチし、キャッシュに保存しない。"
        case .returnCacheDataDontFetch:
            return "利用可能であればキャッシュからデータを返し、そうでなければエラーを返す。"
        case .returnCacheDataAndFetch:
            return "利用可能であればキャッシュからデータを返し、常にサーバから結果をフェッチする。"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
