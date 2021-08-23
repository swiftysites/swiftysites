import Foundation

public struct Post: Content {
    public let file: URL
    public let title: String
    public let author: String
    public let markdown: String

    public init(file: URL, title: String, author: String, markdown: String) {
        self.file = file
        self.title = title
        self.author = author
        self.markdown = markdown
    }
}
