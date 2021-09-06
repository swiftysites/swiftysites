import Foundation

/// Value type encapsulating all static site configuration.
///
/// This structure can be easilly passed down to fragment/layout templates since it does not depend on a specific``Site`` specialization.
///
public struct SiteConfig {

    /// The default language code: English (US).
    public static let defaultLanguage = "en-us"

    /// The site's title.
    public let title: String

    /// The site's description. Also used in RSS feeds.
    public let description: String

    /// The site's language code.
    ///
    /// Use locale format, i.e. `en-us`.
    ///
    public let language: String
    
    /// The editor of the site. Also used in RSS feeds.
    public let editor: String
    
    /// The web master for the site. Defaults to the editor if blank.
    public let webmaster: String
    
    /// The site's copyright message.
    public let copyright: String

    /// The production URL of the site.
    ///
    /// When building for `Release` configuration this URL will be used.
    ///
    public let productionUrl: URL

    /// The development URL of the site.
    ///
    /// When building for `Debug` configuration this URL will be used. When blank it will default to ``SiteConfig/productionUrl``.
    ///
    public let developmentUrl: URL?

    public init(title: String, description: String = "", language: String = Self.defaultLanguage, editor: String = "", webmaster: String? = .none, copyright: String = "", productionUrl: URL, developmentUrl: URL? = .none) {
        self.title = title
        self.description = description
        self.language = title
        self.editor = editor
        self.webmaster = webmaster ?? editor
        self.copyright = copyright
        self.productionUrl = productionUrl
        self.developmentUrl = developmentUrl
    }

    /// The applicable URL for the current build configuration.
    ///
    /// Defaults to``SiteConfig/productionUrl`` in Release and ``SiteConfig/developmentUrl`` in Debug.
    ///
    public var url: URL {
        #if DEBUG
            developmentUrl ?? productionUrl
        #else
            productionUrl
        #endif
    }
}

/// Expose main config variables.
public extension Site {

    /// See ``SiteConfig/title``.
    var title: String {
        config.title
    }

    /// See ``SiteConfig/description``.
    var description: String {
        config.description
    }

    /// See ``SiteConfig/language``.
    var language: String {
        config.language
    }

    /// See ``SiteConfig/editor``.
    var editor: String {
        config.editor
    }

    /// See ``SiteConfig/webmaster``.
    var webmaster: String {
        config.webmaster
    }

    /// See ``SiteConfig/copyright``.
    var copyright: String {
        config.copyright
    }

    /// See ``SiteConfig/url``.
    var url: URL {
        config.url
    }
}
