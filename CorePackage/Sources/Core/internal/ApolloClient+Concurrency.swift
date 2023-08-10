import Foundation
import Apollo
import ApolloAPI

extension ApolloClient {
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .default,
        contextIdentifier: UUID? = nil,
        queue: DispatchQueue = .main
    ) async throws -> Query.Data? {
        return try await withCheckedThrowingContinuation { continuation in
            fetch(query: query, cachePolicy: cachePolicy, contextIdentifier: contextIdentifier, queue: queue) {  result in
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
