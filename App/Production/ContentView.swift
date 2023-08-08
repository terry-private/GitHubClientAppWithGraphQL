import SwiftUI
import Core
import GitHubSchema

struct ContentView: View {
    @AppStorage("token") var token = ""
    @State var client = GraphQLClient.shared
    @State var tokenInput: String = UserDefaults.standard.string(forKey: "token") ?? ""
    @State var repositories: [SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository] = []
    @State var searchWord: String = ""
    
    var body: some View {
        VStack {
            if token == "" {
                SecureField("GitHub tokenを入力", text: $tokenInput)
                Button {
                    client.setToken(token: tokenInput)
                } label: {
                    Text("set!!")
                }
            } else {
                HStack {
                    TextField("検索ワード", text: $searchWord)
                    Button {
                        Task {
                            let data = try? await client.searchRepositories(word: searchWord)
                            guard let edgeds = data?.search.edges else { return }
                            repositories = edgeds.compactMap { $0?.node?.asRepository }
                        }
                    } label: {
                        Text("Search!!")
                    }
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
                    Text("rest token!!")
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
