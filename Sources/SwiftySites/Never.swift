/// Makes `Never` conform with the ``Content`` protocol.
extension Never: Content {

    /// Compliance with the ``Content`` protocol.
    public var path: String {
        fatalError()
    }
}
