import Foundation
import GitHubSchema

extension GetRepositoryQuery.Data: Translator {
    func toModel() throws -> DetailedRepository {
        guard let repository else {
            throw TranslateError.null
        }
        return DetailedRepository(
            id: DetailedRepository.ID(rawValue: repository.id),
            name: repository.name,
            description: repository.description,
            url: repository.url,
            forkCount: repository.forkCount,
            stargazerCount: repository.stargazerCount,
            watchersCount: repository.watchers.totalCount,
            owner: try repository.owner.toModel(),
            language: try repository.primaryLanguage?.toModel())
    }
}

extension GetRepositoryQuery.Data.Repository.Owner: Translator {
    func toModel() throws -> Owner {
        if let asOrganization {
            return Owner(
                id: Owner.ID(rawValue: asOrganization.id),
                avatarURL: URL(string: asOrganization.avatarUrl),
                name: asOrganization.name
            )
        }
        if let asUser {
            return Owner(
                id: Owner.ID(rawValue: asUser.id),
                avatarURL: URL(string: asUser.avatarUrl),
                name: asUser.name
            )
        }
        throw TranslateError.null
    }
}

extension GetRepositoryQuery.Data.Repository.PrimaryLanguage: Translator {
    func toModel() throws -> Language {
        Language(id: Language.ID(rawValue: id), name: name, hexColor: color)
    }
}
