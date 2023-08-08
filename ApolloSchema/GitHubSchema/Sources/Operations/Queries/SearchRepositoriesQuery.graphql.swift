// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SearchRepositoriesQuery: GraphQLQuery {
  public static let operationName: String = "SearchRepositories"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SearchRepositories($query: String = "", $count: Int = 20, $after: String) { search(query: $query, type: REPOSITORY, first: $count, after: $after) { __typename edges { __typename cursor node { __typename ... on Repository { id name stargazerCount owner { __typename ... on Organization { id avatarUrl name } ... on User { id name avatarUrl } } } } } } }"#
    ))

  public var query: GraphQLNullable<String>
  public var count: GraphQLNullable<Int>
  public var after: GraphQLNullable<String>

  public init(
    query: GraphQLNullable<String> = "",
    count: GraphQLNullable<Int> = 20,
    after: GraphQLNullable<String>
  ) {
    self.query = query
    self.count = count
    self.after = after
  }

  public var __variables: Variables? { [
    "query": query,
    "count": count,
    "after": after
  ] }

  public struct Data: GitHubSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("search", Search.self, arguments: [
        "query": .variable("query"),
        "type": "REPOSITORY",
        "first": .variable("count"),
        "after": .variable("after")
      ]),
    ] }

    /// Perform a search across resources, returning a maximum of 1,000 results.
    public var search: Search { __data["search"] }

    /// Search
    ///
    /// Parent Type: `SearchResultItemConnection`
    public struct Search: GitHubSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.SearchResultItemConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("edges", [Edge?]?.self),
      ] }

      /// A list of edges.
      public var edges: [Edge?]? { __data["edges"] }

      /// Search.Edge
      ///
      /// Parent Type: `SearchResultItemEdge`
      public struct Edge: GitHubSchema.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.SearchResultItemEdge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cursor", String.self),
          .field("node", Node?.self),
        ] }

        /// A cursor for use in pagination.
        public var cursor: String { __data["cursor"] }
        /// The item at the end of the edge.
        public var node: Node? { __data["node"] }

        /// Search.Edge.Node
        ///
        /// Parent Type: `SearchResultItem`
        public struct Node: GitHubSchema.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Unions.SearchResultItem }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .inlineFragment(AsRepository.self),
          ] }

          public var asRepository: AsRepository? { _asInlineFragment() }

          /// Search.Edge.Node.AsRepository
          ///
          /// Parent Type: `Repository`
          public struct AsRepository: GitHubSchema.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = SearchRepositoriesQuery.Data.Search.Edge.Node
            public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.Repository }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("id", GitHubSchema.ID.self),
              .field("name", String.self),
              .field("stargazerCount", Int.self),
              .field("owner", Owner.self),
            ] }

            public var id: GitHubSchema.ID { __data["id"] }
            /// The name of the repository.
            public var name: String { __data["name"] }
            /// Returns a count of how many stargazers there are on this object
            public var stargazerCount: Int { __data["stargazerCount"] }
            /// The User owner of the repository.
            public var owner: Owner { __data["owner"] }

            /// Search.Edge.Node.AsRepository.Owner
            ///
            /// Parent Type: `RepositoryOwner`
            public struct Owner: GitHubSchema.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Interfaces.RepositoryOwner }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .inlineFragment(AsOrganization.self),
                .inlineFragment(AsUser.self),
              ] }

              public var asOrganization: AsOrganization? { _asInlineFragment() }
              public var asUser: AsUser? { _asInlineFragment() }

              /// Search.Edge.Node.AsRepository.Owner.AsOrganization
              ///
              /// Parent Type: `Organization`
              public struct AsOrganization: GitHubSchema.InlineFragment {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public typealias RootEntityType = SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository.Owner
                public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.Organization }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("id", GitHubSchema.ID.self),
                  .field("avatarUrl", GitHubSchema.URI.self),
                  .field("name", String?.self),
                ] }

                public var id: GitHubSchema.ID { __data["id"] }
                /// A URL pointing to the organization's public avatar.
                public var avatarUrl: GitHubSchema.URI { __data["avatarUrl"] }
                /// The organization's public profile name.
                public var name: String? { __data["name"] }
              }

              /// Search.Edge.Node.AsRepository.Owner.AsUser
              ///
              /// Parent Type: `User`
              public struct AsUser: GitHubSchema.InlineFragment {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public typealias RootEntityType = SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository.Owner
                public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.User }
                public static var __selections: [ApolloAPI.Selection] { [
                  .field("id", GitHubSchema.ID.self),
                  .field("name", String?.self),
                  .field("avatarUrl", GitHubSchema.URI.self),
                ] }

                public var id: GitHubSchema.ID { __data["id"] }
                /// The user's public profile name.
                public var name: String? { __data["name"] }
                /// A URL pointing to the user's public avatar.
                public var avatarUrl: GitHubSchema.URI { __data["avatarUrl"] }
              }
            }
          }
        }
      }
    }
  }
}
