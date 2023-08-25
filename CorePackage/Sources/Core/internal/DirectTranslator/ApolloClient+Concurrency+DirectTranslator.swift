import Foundation
import Apollo
import ApolloAPI

extension ApolloClient {
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .default,
        contextIdentifier: UUID? = nil,
        queue: DispatchQueue = .main
    ) async throws -> Query.Data.Model where Query.Data: DirectTranslatorProtocol {
        return try await withCheckedThrowingContinuation { continuation in
            fetch(query: query, cachePolicy: cachePolicy, contextIdentifier: contextIdentifier, queue: queue) {  result in
                switch result {
                case .success(let graphQLResult):
                    guard let data = graphQLResult.data else {
                        continuation.resume(throwing: TranslateError.null)
                        return
                    }
                    do {
                        continuation.resume(returning: try data.toModel())
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
