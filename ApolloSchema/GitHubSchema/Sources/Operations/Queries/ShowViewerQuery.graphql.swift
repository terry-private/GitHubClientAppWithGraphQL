// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ShowViewerQuery: GraphQLQuery {
  public static let operationName: String = "ShowViewer"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ShowViewer { viewer { __typename id name email avatarUrl company } }"#
    ))

  public init() {}

  public struct Data: GitHubSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("viewer", Viewer.self),
    ] }

    /// The currently authenticated user.
    public var viewer: Viewer { __data["viewer"] }

    /// Viewer
    ///
    /// Parent Type: `User`
    public struct Viewer: GitHubSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GitHubSchema.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", GitHubSchema.ID.self),
        .field("name", String?.self),
        .field("email", String.self),
        .field("avatarUrl", GitHubSchema.URI.self),
        .field("company", String?.self),
      ] }

      public var id: GitHubSchema.ID { __data["id"] }
      /// The user's public profile name.
      public var name: String? { __data["name"] }
      /// The user's publicly visible profile email.
      public var email: String { __data["email"] }
      /// A URL pointing to the user's public avatar.
      public var avatarUrl: GitHubSchema.URI { __data["avatarUrl"] }
      /// The user's public profile company.
      public var company: String? { __data["company"] }
    }
  }
}
