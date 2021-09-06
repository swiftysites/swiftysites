/// A content type that represents an individual tag.
///
/// Use a ``Site/Generator`` to produce a `TagPage` content item for each available tag. Match with a ``Site/Template`` to list all posts tagged with the specific term.
///
public struct TagPage: Content {
    public let path: String
    public let tag: String

    public init(_ path: String, tag: String) {
        self.path = path
        self.tag = tag
    }
}
