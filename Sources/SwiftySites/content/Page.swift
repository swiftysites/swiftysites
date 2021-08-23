import Foundation

public struct Page: Content {
    public let globalTemplateOnly: Bool
    public let file: URL
    public let title: String
    public let markdown: String

    public init(globalTemplateOnly: Bool = false, file: URL, title: String, markdown: String) {
        self.globalTemplateOnly = globalTemplateOnly
        self.file = file
        self.title = title
        self.markdown = markdown
    }
}
