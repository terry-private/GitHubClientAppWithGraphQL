import Foundation
import GitHubSchema

extension SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository.Owner: Translator {
    typealias Model = Owner
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
