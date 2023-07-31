// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetUserQuery: GraphQLQuery {
  public static let operationName: String = "GetUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetUser($login: String!) { user(login: $login) { __typename login name url repositories(last: 20) { __typename totalCount nodes { __typename id name description createdAt updatedAt url } } } }"#
    ))

  public var login: String

  public init(login: String) {
    self.login = login
  }

  public var __variables: Variables? { ["login": login] }

  public struct Data: GitHubSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["login": .variable("login")]),
    ] }

    /// Lookup a user by login.
    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `User`
    public struct User: GitHubSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("login", String.self),
        .field("name", String?.self),
        .field("url", GitHubSchema.URI.self),
        .field("repositories", Repositories.self, arguments: ["last": 20]),
      ] }

      /// The username used to login.
      public var login: String { __data["login"] }
      /// The user's public profile name.
      public var name: String? { __data["name"] }
      /// The HTTP URL for this user
      public var url: GitHubSchema.URI { __data["url"] }
      /// A list of repositories that the user owns.
      public var repositories: Repositories { __data["repositories"] }

      /// User.Repositories
      ///
      /// Parent Type: `RepositoryConnection`
      public struct Repositories: GitHubSchema.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.RepositoryConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("totalCount", Int.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int { __data["totalCount"] }
        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// User.Repositories.Node
        ///
        /// Parent Type: `Repository`
        public struct Node: GitHubSchema.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.Repository }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GitHubSchema.ID.self),
            .field("name", String.self),
            .field("description", String?.self),
            .field("createdAt", GitHubSchema.DateTime.self),
            .field("updatedAt", GitHubSchema.DateTime.self),
            .field("url", GitHubSchema.URI.self),
          ] }

          public var id: GitHubSchema.ID { __data["id"] }
          /// The name of the repository.
          public var name: String { __data["name"] }
          /// The description of the repository.
          public var description: String? { __data["description"] }
          /// Identifies the date and time when the object was created.
          public var createdAt: GitHubSchema.DateTime { __data["createdAt"] }
          /// Identifies the date and time when the object was last updated.
          public var updatedAt: GitHubSchema.DateTime { __data["updatedAt"] }
          /// The HTTP URL for this repository
          public var url: GitHubSchema.URI { __data["url"] }
        }
      }
    }
  }
}
