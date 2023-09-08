import SwiftUI
import Core
import Apollo

struct SearchView: View {    
    @StateObject var viewState: SearchViewState = .init(tokenStore: .forProduction)
    
    init() {}
    
    var body: some View {
        VStack {
            if viewState.isShowInputTokenView {
                SecureField("GitHub tokenを入力", text: $viewState.inputToken)
                Button {
                    viewState.tokenSetButtonTapped()
                } label: {
                    Text("set!!")
                        .padding(4)
                }
            } else {
                TextField("検索ワード", text: $viewState.searchWord)
                    .padding()
                    .background(Color.gray.cornerRadius(10).opacity(0.2))
                
                Picker("cachePolicy", selection: $viewState.selectedCachePolicy) {
                    ForEach(CachePolicy.allCases, id: \.self.title) { cachePolicy in
                        Text(cachePolicy.title).tag(cachePolicy)
                    }
                }
                Text(viewState.selectedCachePolicy.description)
                
                HStack {
                    VStack {
                        Text("メモリキャッシュ")
                        Button {
                            viewState.inMemoryClientFetchButtonTapped()
                        } label: {
                            Text("fetch")
                                .padding(4)
                        }
                        Button {
                            viewState.inMemoryClientReadCacheButtonTapped()
                        } label: {
                            Text("read cache")
                                .padding(4)
                        }
                        Button {
                            viewState.inMemoryClientClearCacheButtonTapped()
                        } label: {
                            Text("clear cache")
                                .padding(4)
                        }
                    }
                    .padding()
                    
                    VStack {
                        Text("SQLiteキャッシュ")
                        
                        Button {
                            viewState.sqliteClientFetchButtonTapped()
                        } label: {
                            Text("fetch")
                                .padding(4)
                        }
                        
                        Button {
                            viewState.sqliteClientReadCacheButtonTapped()
                        } label: {
                            Text("read cache")
                                .padding(4)
                        }
                        
                        Button {
                            viewState.sqliteClientClearCacheButtonTapped()
                        } label: {
                            Text("clear cache")
                                .padding(4)
                        }
                    }
                    .padding()
                }
                
                Button {
                    viewState.clearListButtonTapped()
                } label: {
                    Text("clear list")
                }
                
                List {
                    ForEach(viewState.repositories, id: \.self.id) { repository in
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
                    viewState.resetTokenButtonTapped()
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
