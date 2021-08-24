import Foundation
import CMarkGFM

public protocol Content {
    var globalTemplateOnly: Bool { get }
    var file: URL { get }
    var title: String { get }
    var markdown: String { get } // https://github.com/github/cmark-gfm
    var html: String { get }
}

public extension Content { // Default protocol implementation
    var globalTemplateOnly: Bool {
        false
    }

    var title: String {
        file.lastPathComponent.uppercased() // Derive a default title from the file name
    }

    var html: String {
        GFMarkdown(markdown).toHTML()
    }
}
