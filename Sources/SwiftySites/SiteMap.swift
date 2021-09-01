import Foundation

public struct SiteMap {
    public let urls: [URL]
    public let generatesSitemapFile: Bool

    var sitemapFile: URL? {
        generatesSitemapFile ? URL(string: "/sitemap.xml") : .none
    }

    var xmlContents: String { """
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
