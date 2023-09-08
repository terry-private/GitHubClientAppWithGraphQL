import ApolloAPI

extension GraphQLNullable where Wrapped == String {
    init(_ wrapped: String?) {
        guard let wrapped else {
            self.init(nilLiteral: ())
            return
        }
        self.init(stringLiteral: wrapped)
    }
}
