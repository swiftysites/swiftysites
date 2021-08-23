import SwiftySites

func basic_layoutTemplate(_ config: SiteConfig, _ page: Page, top: String, bottom: String? = .none) -> String {
    """
    <html>
        <head>
            <title>\(config.title) - \(page.title)</title>
        </head>
        <body>
            <!-- Top Content -->
            \(top)
            <hr />
            <!-- Bottom Content -->
            \(bottom ??
                """
                Content not available.
                """
            )
        </body>
    </html>
    """
}
