// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetRepositoryQuery: GraphQLQuery {
  public static let operationName: String = "GetRepository"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetRepository($name: String!, $owner: String!) { repository(name: $name, owner: $owner) { __typename id name description url forkCount stargazerCount watchers { __typename totalCount } owner { __typename id avatarUrl ... on User { name } ... on Organization { name } } primaryLanguage { __typename id name color } } }"#
    ))

  public var name: String
  public var owner: String

  public init(
    name: String,
    owner: String
  ) {
    self.name = name
    self.owner = owner
  }

  public var __variables: Variables? { [
    "name": name,
    "owner": owner
  ] }

  public struct Data: GitHubSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("repository", Repository?.self, arguments: [
        "name": .variable("name"),
        "owner": .variable("owner")
      ]),
    ] }

    /// Lookup a given repository by the owner and repository name.
    public var repository: Repository? { __data["repository"] }

    /// Repository
    ///
    /// Parent Type: `Repository`
    public struct Repository: GitHubSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.Repository }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", GitHubSchema.ID.self),
        .field("name", String.self),
        .field("description", String?.self),
        .field("url", GitHubSchema.URI.self),
        .field("forkCount", Int.self),
        .field("stargazerCount", Int.self),
        .field("watchers", Watchers.self),
        .field("owner", Owner.self),
        .field("primaryLanguage", PrimaryLanguage?.self),
      ] }

      public var id: GitHubSchema.ID { __data["id"] }
      /// The name of the repository.
      public var name: String { __data["name"] }
      /// The description of the repository.
      public var description: String? { __data["description"] }
      /// The HTTP URL for this repository
      public var url: GitHubSchema.URI { __data["url"] }
      /// Returns how many forks there are of this repository in the whole network.
      public var forkCount: Int { __data["forkCount"] }
      /// Returns a count of how many stargazers there are on this object
      public var stargazerCount: Int { __data["stargazerCount"] }
      /// A list of users watching the repository.
      public var watchers: Watchers { __data["watchers"] }
      /// The User owner of the repository.
      public var owner: Owner { __data["owner"] }
      /// The primary language of the repository's code.
      public var primaryLanguage: PrimaryLanguage? { __data["primaryLanguage"] }

      /// Repository.Watchers
      ///
      /// Parent Type: `UserConnection`
      public struct Watchers: GitHubSchema.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.UserConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("totalCount", Int.self),
        ] }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int { __data["totalCount"] }
      }

      /// Repository.Owner
      ///
      /// Parent Type: `RepositoryOwner`
      public struct Owner: GitHubSchema.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Interfaces.RepositoryOwner }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GitHubSchema.ID.self),
          .field("avatarUrl", GitHubSchema.URI.self),
          .inlineFragment(AsUser.self),
          .inlineFragment(AsOrganization.self),
        ] }

        public var id: GitHubSchema.ID { __data["id"] }
        /// A URL pointing to the owner's public avatar.
        public var avatarUrl: GitHubSchema.URI { __data["avatarUrl"] }

        public var asUser: AsUser? { _asInlineFragment() }
        public var asOrganization: AsOrganization? { _asInlineFragment() }

        /// Repository.Owner.AsUser
        ///
        /// Parent Type: `User`
        public struct AsUser: GitHubSchema.InlineFragment {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public typealias RootEntityType = GetRepositoryQuery.Data.Repository.Owner
          public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("name", String?.self),
          ] }

          /// The user's public profile name.
          public var name: String? { __data["name"] }
          public var id: GitHubSchema.ID { __data["id"] }
          /// A URL pointing to the owner's public avatar.
          public var avatarUrl: GitHubSchema.URI { __data["avatarUrl"] }
        }

        /// Repository.Owner.AsOrganization
        ///
        /// Parent Type: `Organization`
        public struct AsOrganization: GitHubSchema.InlineFragment {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public typealias RootEntityType = GetRepositoryQuery.Data.Repository.Owner
          public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.Organization }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("name", String?.self),
          ] }

          /// The organization's public profile name.
          public var name: String? { __data["name"] }
          public var id: GitHubSchema.ID { __data["id"] }
          /// A URL pointing to the owner's public avatar.
          public var avatarUrl: GitHubSchema.URI { __data["avatarUrl"] }
        }
      }

      /// Repository.PrimaryLanguage
      ///
      /// Parent Type: `Language`
      public struct PrimaryLanguage: GitHubSchema.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.Language }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GitHubSchema.ID.self),
          .field("name", String.self),
          .field("color", String?.self),
        ] }

        public var id: GitHubSchema.ID { __data["id"] }
        /// The name of the current language.
        public var name: String { __data["name"] }
        /// The color defined for the current language.
        public var color: String? { __data["color"] }
      }
    }
  }
}
