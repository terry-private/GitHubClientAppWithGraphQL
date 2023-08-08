import SwiftUI
import Core
import GitHubSchema

struct ContentView: View {
    @AppStorage("token") var token = ""
    @State var client = GraphQLClient.shared
    @State var repository: GetRepositoryQuery.Data.Repository?
    @State var tokenInput: String = UserDefaults.standard.string(forKey: "token") ?? ""
    
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
                Button {
                    Task {
                        let repositoryData = try? await client.getRepository(owner: "apple", name: "swift")
                        repository = repositoryData?.repository
                    }
                } label: {
                    Text("fetch!!")
                }
                Text("\(repository?.name ?? "")")
                
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
