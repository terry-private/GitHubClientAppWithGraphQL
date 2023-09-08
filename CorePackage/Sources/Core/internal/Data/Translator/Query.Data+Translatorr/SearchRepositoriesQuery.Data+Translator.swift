import Foundation
import GitHubSchema

extension SearchRepositoriesQuery.Data: Translator {
    func toModel() throws -> [SeachedRepository] {
        guard let edges = self.search.edges else {
            throw TranslateError.null
        }
        var repositories: [SeachedRepository] = []
        for edge in edges {
            do {
                guard let repository = try edge?.node?.asRepository?.toModel()  else {
                    throw TranslateError.unexpected
                }
                repositories.append(repository)
            } catch {
                print(error.localizedDescription)
                throw error
            }
        }
        return repositories
    }
}

extension SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository: Translator {
    func toModel() throws -> SeachedRepository {
        let owner = try owner.toModel()
        return SeachedRepository(
            id: SeachedRepository.ID(rawValue: id),
            name: name,
            stargazerCount: stargazerCount,
            owner: owner
        )
    }
}

extension SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository.Owner: Translator {
    func toModel() throws -> Owner {
        if let organization = asOrganization {
            return Owner(
                id: Owner.ID(rawValue: organization.id),
                avatarURL: URL(string: organization.avatarUrl),
                name: organization.name
            )
        }
        if let user = asUser {
            return Owner(
                id: Owner.ID(rawValue: user.id),
                avatarURL: URL(string: user.avatarUrl),
                name: user.name
            )
        }
        throw TranslateError.null
    }
}
