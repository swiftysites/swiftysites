import Foundation

/// A content type representing a tagged blog post.
///
/// Each post can contain a series of labels or tags that can be used to generate indexes.
///
public struct TaggedPost: Content {

    /// The path of this content item.
    public let path: String

    /// The post's display title.
    public let title: String

    /// The author of this post.
    public let author: String

    /// The date this post was published.
    public let date: Date

    /// The topics covered by this post.
    public let tags: [String]

    /// The Markdown content of this post.
    @Markdown public private(set) var content: String
}

/// Public `TaggedPost` properties.
public extension TaggedPost {

    /// Concisely initialize a post.
    ///
    /// Use a trailing closure to improve readability.
    ///
    init(_ path: String, _ title: String, _ author: String, _ date: String, _ tags: [String] = [], content: () -> String) {
        self.path = path
        self.title = title
        self.author = author
        guard let date = ISO8601DateFormatter().date(from: date) else {
            fatalError("Please use ISO8601 format for dates. Example, '2021-08-15T12:33:00Z'.")
        }
        self.date = date
        self.tags = tags
        self.content = content()
    }

    /// The post's published date formatted for human-readable display.
    var dateFormatted: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }

    /// The post's date formatted for use in an RSS feed.
    var dateRssFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
        return dateFormatter.string(from: date) // // Mon, 02 Jan 2006 15:04:05 -0700
    }

    /// Use to sort an array of posts.
    static func dateDescendingOrder(_ l: Self, _ r: Self) -> Bool {
        l.date > r.date
    }
}

public extension Array where Element == TaggedPost {

    /// All available tags in ascending order by name.
    var tags: [String] {
        var tags = Set<String>()
        forEach {
            $0.tags.forEach {
                tags.insert($0)
            }
        }
        return [String](tags).sorted { $0 < $1 }
    }
}
