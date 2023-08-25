protocol DirectTranslatorProtocol {
    associatedtype Model
    func toModel() throws -> Model
}
