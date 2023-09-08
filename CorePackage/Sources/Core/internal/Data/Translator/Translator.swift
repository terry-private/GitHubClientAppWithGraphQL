protocol Translator {
    associatedtype Model
    func toModel() throws -> Model
}
