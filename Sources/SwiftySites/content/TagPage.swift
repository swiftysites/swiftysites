/// A content type that represents a listing of articles under a particular tag.
public struct TagPage: Content, Sendable {
    public let path: String
    public let tag: String

    public init(_ path: String, tag: String) {
        self.path = path
        self.tag = tag
    }
}
