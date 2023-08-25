import Foundation
import GitHubSchema

extension SearchRepositoriesQuery.Data: DirectTranslatorProtocol {
    func toModel() throws -> [Repository] {
        guard let edges = self.search.edges else {
            throw TranslateError.null
        }
        return try edges.map {
            guard let repository = try $0?.node?.asRepository?.toModel()  else {
                throw TranslateError.null
            }
            return repository
        }
    }
}

extension SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository: DirectTranslatorProtocol {
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

extension SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository.Owner: DirectTranslatorProtocol {
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
