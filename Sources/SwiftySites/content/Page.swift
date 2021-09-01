import Foundation

public struct Page: Content {
    public let file: URL
    public let title: String
    public let markdown: String

    /// Default initializer.
    public init(path: String, title: String, markdown: String) {
        self.file = URL(fileURLWithPath: path)
        self.title = title
        self.markdown = markdown
    }

    /// Short-form initializer.
    public init(_ path: String, _ title: String, markdown: () -> String) {
        self.init(path: path, title: title, markdown: markdown())
    }
}
