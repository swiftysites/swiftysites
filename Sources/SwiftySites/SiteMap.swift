import Foundation

/// A map containing all of the site's entry points.
public struct SiteMap: Sendable {

    /// All of the site's entry points.
    public let urls: [URL]

    /// Whether a `sitemap.xml` file should be generated.
    public let generatesSitemapFile: Bool

    /// The path for the sitemap file`/sitemap.xml` when ``generatesSitemapFile`` is set.
    public var sitemapFile: URL? {
        generatesSitemapFile ? URL(string: "/sitemap.xml") : .none
    }

    /// The contents of the sitemap file.
    ///
    /// The content is returned regardless of whether a sitemap file is part of the rendered site.
    ///
    public var xmlContents: String { """
    <?xml version="1.0" encoding="utf-8" standalone="yes"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
        \(urls.map { """
        <url>
            <loc>\($0)</loc>
        </url>
        """ }.joined())
    </urlset>
    """ }
}
