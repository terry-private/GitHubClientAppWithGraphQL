import Foundation

public struct Owner: Identifiable, Equatable {
    public struct ID: RawRepresentable, Hashable, Codable {
        public var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    public var id: ID
    public var avatarURL: URL?
    public var name: String?
}
