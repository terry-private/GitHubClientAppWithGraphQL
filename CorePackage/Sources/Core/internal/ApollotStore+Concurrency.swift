import Foundation
import Apollo
import ApolloAPI

extension ApolloStore {
    func withinReadTransaction<Query>(
      _ query: Query
    ) async throws -> Query.Data.Model where Query: GraphQLQuery, Query.Data: Translator {
        return try await withCheckedThrowingContinuation { continuation in
            withinReadTransaction({ transaction in
                do {
                    let data = try transaction.read(query: query)
                    do {
                        continuation.resume(returning: try data.toModel())
                    } catch {
                        continuation.resume(throwing: error)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            })
        }
    }
}
