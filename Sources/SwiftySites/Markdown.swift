import GFMarkdown

/// Property wrapper to turn any Markdown variable into HTML.
///
/// Basic usage.
///
/// ```swift
/// @Markdown var content = "# Hello"
///
/// // Automatic HTML conversion.
/// print(content) // "<h1>Hello</h1>"
///
/// // Maintain access to original Markdown.
/// print($content) // "# Hello"
/// ```
///
@propertyWrapper public struct Markdown {

    /// Converts to HTML using `GFMarkdown/MarkdownString``.
    private static func toHTML(_ value: String) -> String {
        MarkdownString(value).toHTML(options: [.validateUTF8, .unsafe], extensions: [.tagfilter, .autolink, .strikethrough, .table, .tasklist])
    }

    /// The converted HTML value accessible through the wrappedValue property.
    private var html: String

    /// Access the original value before conversion by prefixing the property name with `$`.
    ///
    /// Example.
    ///
    /// ```swift
    /// struct Page {
    ///     @Markdown var content: String
    /// }
    ///
    /// var page = Page(content: "# Hello")
    /// page.content // "<h1>Hello</h1>"
    /// page.$content // "# Hello"
    /// ```
    ///
    public private(set) var projectedValue: String

    /// The HTML translation of the original Markdown value.
    public var wrappedValue: String {

        /// HTML value.
        get {
            html
        }

        /// Applies the Markdown conversion and saves the original value.
        set {
            projectedValue = newValue
            html = Self.toHTML(newValue)
        }
    }

    /// Applies the Markdown conversion and saves the original value.
    public init(wrappedValue: String) {
        projectedValue = wrappedValue
        html = Self.toHTML(wrappedValue)
    }
}
