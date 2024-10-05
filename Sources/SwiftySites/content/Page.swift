import Foundation

/// A content type representing a regular page.
public struct Page: Content, Sendable {

    /// The path of this content item.
    public let path: String

    /// The post's display title.
    public let title: String

    /// The Markdown/HTML content of this page.
    ///
    /// Initialize this variable with Markdown code. When accessing this property the corresponding HTML will be returned.
    /// Use `$content` to get back the original value before converting.
    ///
    @Markdown public private(set) var content: String
}

public extension Page {

    /// Concisely initialize a page.
    ///
    /// Use a trailing closure to improve readability.
    ///
    init(_ path: String, _ title: String, content: () -> String) {
        self.init(path: path, title: title, content: content())
    }
}
