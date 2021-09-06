import CMarkGFM

/// Property wrapper to turn any Markdown variable into HTML.
@propertyWrapper public struct Markdown {

    /// Converts Markdown to HTML.
    ///
    /// CMark options: `validateUTF8`, `unsafe`.
    /// GFM extensions: `tagfilter`, `autolink`, `strikethrough`, `table`, `tasklist`.
    ///
    static func convert(_ value: String) -> String {
        GFMarkdown(value).toHTML(options: [.validateUTF8, .unsafe], extensions: [.tagfilter, .autolink, .strikethrough, .table, .tasklist])
    }

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

        /// Applies the Markdown conversion and saves the original value.
        didSet {
            projectedValue = wrappedValue
            self.wrappedValue = Self.convert(wrappedValue)
        }
    }

    /// Applies the Markdown conversion and saves the original value.
    public init(wrappedValue: String) {
        projectedValue = wrappedValue
        self.wrappedValue = Self.convert(wrappedValue)
    }
}
