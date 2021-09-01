import Foundation

public struct Post: Content {
    public let file: URL
    public let title: String
    public let author: String
    public let date: Date
    public let markdown: String

    public init(_ path: String, _ title: String, _ author: String, _ date: String, markdown: () -> String) {
        self.file = URL(fileURLWithPath: path)
        self.title = title
        self.author = author
        guard let date = ISO8601DateFormatter().date(from: date) else {
            fatalError("Please use ISO8601 format for dates. Example, '2021-08-15T12:33:00Z'.")
        }
        self.date = date
        self.markdown = markdown()
    }
}

public extension Post {
    var dateFormatted: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }

    static func dateDescendingOrder(_ l: Post, _ r: Post) -> Bool {
        l.date > r.date
    }
}
