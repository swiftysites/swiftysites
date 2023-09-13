import XCTest
import SwiftySites

fileprivate struct Page: Content {
    var path: String
    var contents: String
}

fileprivate struct Article: Content {
    var path: String
    var title: String
    @Markdown var body: String
}

final class SwiftySitesTests: XCTestCase {
    
    func testBasicSite() {
        let config = SiteConfig(title: "My Site", productionUrl: URL(string: "https://swiftysites.dev")!)
        
        let articles = [
            Article(path: "/articles/fish", title: "Fish" , body: "Many _fish_."),
            .init(path: "/articles/turtles", title: "Turtles", body: "Turtles **all the way** down.")
        ]

        func getArticleLinks() -> String {
            articles.map(\.title).joined()
        }

        let pages = [
            Page(path: "/", contents: "Home Page \(getArticleLinks())"),
            .init(path: "/about", contents: "About"),
        ]
        
        let pageTemplates = [
            Template { (p: Page) in
                "<title>\(config.title)</title><body>\(p.contents)</body>"
            }
        ]
        
        let articleTemplates = [
            Template<Article>(exclude: #/\/articles\/t.*/#) { article in
                "Title: \(article.title); Text: \(article.$body)"
            },
            Template(#/\/articles\/t.*/#, suffix: "json") { (a: Article) in
                "<h1>\(a.title)</h1><main>\(a.body)</main>"
            }
        ]
        
        let site = Site(config, content: (pages, articles), template: (pageTemplates, articleTemplates))
        let result = site.render(clean: true, skipSitemap: true, skipStatic: true)
        print("Results: \(result.urls)")
    }
}
