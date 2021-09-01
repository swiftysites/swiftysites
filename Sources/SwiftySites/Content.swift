import Foundation
import CMarkGFM

public protocol Content {
    var file: URL { get }
    var title: String { get }
    var markdown: String { get } // https://github.com/github/cmark-gfm
    var html: String { get }
    var path: String { get }
}

public extension Content { // Default protocol implementation

    var path: String {
        file.path
    }

    var title: String {
        file.lastPathComponent.uppercased() // Derive a default title from the file name
    }

    var html: String {
        GFMarkdown(markdown).toHTML(options: [.validateUTF8, .unsafe], extensions: [.tagfilter, .autolink, .strikethrough, .table, .tasklist])
    }
}
