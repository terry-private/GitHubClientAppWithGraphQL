import Foundation

public struct Language: Identifiable, Equatable {
    public struct ID: RawRepresentable, Hashable, Codable {
        public var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    public var id: ID
    public var name: String
    public var hexColor: String?
}
