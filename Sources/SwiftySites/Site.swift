import Foundation

/// Defines a site in terms of its content types.
///
/// Rather than using this struct directly to use one of the its aliases like ``BasicSite`` or ``BasicBlog``.
/// Or create your own custom alias based on the multi-content aliases like ``SiteA`` or ``SiteB``.
///
/// Example:
///
/// ```swift
/// typealias MySite = SiteB<Page, Post>
/// ```
///
public struct Site<each C: Content> {

    /// Default and only initializer to create _Site_ instances.
    ///
    /// - Parameters:
    ///   - config: Your site's configuration object.
    ///   - contentA: Initial items of your first content type.
    ///   - contentB: Initial items of your second content type.
    ///   - contentC: Initial items of your third content type.
    ///   - contentD: Initial items of your fourth content type.
    ///   - contentE: Initial items of your fifth content type.
    ///   - templates: Templates will be applied at render time.
    ///   - generators: Generators are applied during initialization and the generated content will be appended to the user-specified content.
    ///
    public init(_ config: SiteConfig, content: (repeat [(each C)]), template: (repeat [Template<each C>])) {
        self.config = config
        self.content = content
        self.template = template
    }

    /// The site's configuration parameters.
    public let config: SiteConfig

    /// Content instances for the corresponding content type.
    ///
    /// You can specify up to five content types.
    ///
    public let content: (repeat [(each C)])

    /// Templates to be applied to content.
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
        let options = RenderCommand.parseOrExit()
        
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
