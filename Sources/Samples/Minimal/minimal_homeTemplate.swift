import SwiftySites

let minimal_homeTemplate = BasicSite.GlobalTemplate(match: #"/"#, suffix: "html") { site, page, _ in
    """
    <html>
    <head><title>\(page!.title)</title></head>
    <body>
        <div>
            \(page!.html)
        </div>
    </body>
    </html>
    """
}
