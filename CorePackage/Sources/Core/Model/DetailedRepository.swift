import Foundation

public struct DetailedRepository: Identifiable, Equatable {
    public struct ID: RawRepresentable, Hashable, Codable {
        public var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    public var id: ID
    public var name: String
    public var description: String
    public var url: String
    public var forkCount: Int
    public var stargazerCount: Int
    public var watchersCount: Int
    public var owner: Owner
    public var language: Language
}
