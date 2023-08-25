import Foundation
import GitHubSchema

protocol EnumTranslatorProtocol {
    static func repositories(from queryData: SearchRepositoriesQuery.Data) throws -> [Repository]
}


enum EnumTranslator: EnumTranslatorProtocol {
    static func repositories(from queryData: SearchRepositoriesQuery.Data) throws -> [Repository] {
        guard let edges = queryData.search.edges else {
            throw GraphQLError.translationFailed
        }
        return try edges.map {
            guard let repository = try $0?.node?.asRepository?.toModel()  else {
                throw GraphQLError.translationFailed
            }
            return repository
        }
    }
}

private extension EnumTranslator {
    static func repository(from queryRepository: SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository) throws -> Repository {
        let owner = try queryRepository.owner.toModel()
        return Repository(
            id: Repository.ID(rawValue: queryRepository.id),
            name: queryRepository.name,
            stargazerCount: queryRepository.stargazerCount,
            owner: owner
        )
    }
    
    static func owner(from queryOwner: SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository.Owner) throws -> Owner {
        if let organization = queryOwner.asOrganization {
            return Owner(
                id: Owner.ID(rawValue: organization.id),
                avatarURL: URL(string: organization.avatarUrl),
                name: organization.name
            )
        }
        if let user = queryOwner.asUser {
            return Owner(
                id: Owner.ID(rawValue: user.id),
                avatarURL: URL(string: user.avatarUrl),
                name: user.name
            )
        }
        throw GraphQLError.translationFailed
    }
}
