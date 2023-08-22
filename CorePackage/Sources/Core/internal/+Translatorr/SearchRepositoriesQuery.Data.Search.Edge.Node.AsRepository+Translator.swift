import Foundation
import GitHubSchema

extension SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository: Translator {
    func toModel() throws -> Repository {
        let owner = try owner.toModel()
        return Repository(
            id: Repository.ID(rawValue: id),
            name: name,
            stargazerCount: stargazerCount,
            owner: owner
        )
    }
}
