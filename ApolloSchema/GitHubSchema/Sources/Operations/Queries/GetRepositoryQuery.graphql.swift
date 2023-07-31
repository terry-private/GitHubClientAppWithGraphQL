// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetRepositoryQuery: GraphQLQuery {
  public static let operationName: String = "GetRepository"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetRepository($owner: String!, $name: String!) { repository(owner: $owner, name: $name) { __typename id name url } }"#
    ))

  public var owner: String
  public var name: String

  public init(
    owner: String,
    name: String
  ) {
    self.owner = owner
    self.name = name
  }

  public var __variables: Variables? { [
    "owner": owner,
    "name": name
  ] }

  public struct Data: GitHubSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("repository", Repository?.self, arguments: [
        "owner": .variable("owner"),
        "name": .variable("name")
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
        .field("url", GitHubSchema.URI.self),
      ] }

      public var id: GitHubSchema.ID { __data["id"] }
      /// The name of the repository.
      public var name: String { __data["name"] }
      /// The HTTP URL for this repository
      public var url: GitHubSchema.URI { __data["url"] }
    }
  }
}
