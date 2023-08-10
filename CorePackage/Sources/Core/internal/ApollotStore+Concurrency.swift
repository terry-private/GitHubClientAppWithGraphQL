import Foundation
import Apollo
import ApolloAPI

extension ApolloStore {
    public func withinReadTransaction<Query>(
      _ query: Query
    ) async throws -> Query.Data where Query: GraphQLQuery {
        return try await withCheckedThrowingContinuation { continuation in
            withinReadTransaction({ transaction in
                do {
                    let data = try transaction.read(query: query)
                    continuation.resume(returning: data)
                } catch {
                    continuation.resume(throwing: error)
                }
            })
        }
    }
}
