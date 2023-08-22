import Foundation

public struct Repository: Identifiable, Equatable {
    public struct ID: RawRepresentable, Hashable, Codable {
        public var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    public var id: ID
    public var name: String
    public var stargazerCount: Int
    public var owner: Owner
}
