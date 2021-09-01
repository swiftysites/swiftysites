import Foundation

public struct SiteConfig {
    public let title: String
    public let productionURL: URL
    public let developmentURL: URL?

    public init(title: String, productionURL: URL, developmentURL: URL? = .none) {
        self.title = title
        self.productionURL = productionURL
        self.developmentURL = developmentURL
    }

    public var baseURL: URL {
        #if DEBUG
            developmentURL ?? productionURL
        #else
            productionURL
        #endif
    }
}
