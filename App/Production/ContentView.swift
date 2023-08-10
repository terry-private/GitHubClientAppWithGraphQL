import SwiftUI
import Core
import GitHubSchema

struct ContentView: View {
    @AppStorage("token") var token = ""
    
    @State var inMemoryClient: GraphQLClient?
    @State var sqliteClient: GraphQLClient?
    
    @State var inputToken: String = UserDefaults.standard.string(forKey: "token") ?? ""
    @State var repositories: [SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository] = []
    @State var searchWord: String = ""
    
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
                }
            } else {
                TextField("検索ワード", text: $searchWord)
                    .padding()
                    .background(Color.gray.cornerRadius(10).opacity(0.2))
                HStack {
                    VStack {
                        Text("メモリキャッシュ")
                        Button {
                            Task {
                                let data = try? await inMemoryClient?.searchRepositories(word: searchWord)
                                let edgeds = data?.search.edges
                                repositories = edgeds?.compactMap { $0?.node?.asRepository } ?? []
                            }
                        } label: {
                            Text("fetch")
                        }
                        Button {
                            Task {
                                let data = try? await inMemoryClient?.searchRepositoriesFromCache(word: searchWord)
                                let edgeds = data?.search.edges
                                repositories = edgeds?.compactMap { $0?.node?.asRepository } ?? []
                            }
                        } label: {
                            Text("read cache")
                        }
                    }
                    .padding()
                    
                    VStack {
                        Text("SQLiteキャッシュ")
                        Button {
                            Task {
                                let data = try? await sqliteClient?.searchRepositories(word: searchWord)
                                let edgeds = data?.search.edges
                                repositories = edgeds?.compactMap { $0?.node?.asRepository } ?? []
                            }
                        } label: {
                            Text("fetch")
                        }
                        Button {
                            Task {
                                let data = try? await sqliteClient?.searchRepositoriesFromCache(word: searchWord)
                                let edgeds = data?.search.edges
                                repositories = edgeds?.compactMap { $0?.node?.asRepository } ?? []
                            }
                        } label: {
                            Text("read cache")
                        }
                    }
                    .padding()
                }
                List {
                    ForEach(repositories, id: \.self.id) { repository in
                        VStack {
                            Text(repository.owner.asUser?.name ?? repository.owner.asOrganization?.name ?? "")
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
                    Text("reset token!!")
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
