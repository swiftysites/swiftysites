import Foundation

/// Defines a site in terms of its content types.
public struct Site<each C: Content>: Sendable {
 
    /// Creates an instance of Site from a set of content elements and templates. The initializer also requires a site configuration.
    /// - Parameters:
    ///   - config: The site's configuration.
    ///   - content: Multiple arrays of related content. Usually one array per content type.
    ///   - template: Multiple arrays of templates for each content group.
    public init(_ config: SiteConfig, content: (repeat [(each C)]), template: (repeat [Template<each C>])) {
        self.config = config
        self.content = content
        self.template = template
    }

    /// The site's configuration parameters.
    public let config: SiteConfig

    /// Content groups. Each group correspond to a specific content type.
    public let content: (repeat [(each C)])

    /// Template groups. Each template group is applied to the corresponding content group.
    public let template: (repeat [Template<each C>])

    /// Generate the static site writing the output to the _www_ folder.
    ///
    /// All parameters can also be specified as command-line arguments. The function's explicit parameters take precedence over values specified on the command line.
    ///
    /// Invoke your executable with `swift run MySite --help` for a list of available flags.
    ///
    /// - Parameters:
    ///  - clean: Deletes the `www` folder entirely before rendering. Defaults to false (will not delete the `www` folder).
    ///  - skipSitemap: Does not generate a sitemap file. Defaults to false (will generate a sitemap).
    ///  - skipStatic: Avoids copying the contents of the `static` folder into the `www` folder. Defaults to false (will copy static).
    ///  
    @discardableResult public func render(clean: Bool? = nil, skipSitemap: Bool? = nil, skipStatic: Bool? = nil) -> SiteMap {
        // Parse the command-line.
        let options = (try? RenderCommand.parse()) ?? RenderCommand()

        // Flags.
        let clean = clean ?? options.clean
        let skipSitemap = skipSitemap ?? options.skipSitemap
        let skipStatic = skipStatic ?? options.skipStatic
        
        if clean { cleanWWW() }
        if !skipStatic { syncStatic() }
        
        // Render site.
        let sitemapUrls = render()
        
        // Create and return sitemap.
        let sitemap = SiteMap(urls: sitemapUrls, generatesSitemapFile: !skipSitemap)
        if let sitemapFile = sitemap.sitemapFile {
            writeFile(sitemap.xmlContents, sitemapFile)
        }
        return sitemap
    }
    
    func render() -> [URL] {
        var files = [URL]()
        
        repeat
        files += ((each template).apply(each content, baseURL: config.url))
        
        return files
    }
}
