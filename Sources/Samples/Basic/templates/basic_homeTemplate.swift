import SwiftySites

let basic_homeTemplate = BasicSite.GlobalTemplate(match: #"/"#, suffix: "html") { site, page, _ in
    """
    \(basic_layoutTemplate(site.config, page!,
        top: """
        <div>
            \(page!.html)
        </div>
        """,
        bottom: """
        <ul class="menu">
            \(site.contentA.reduce("") {
                """
                \($0)
                <li>
                    <a href="\($1.file.relativePath)">\($1.title)</a>
                </li>
                """
            })
        </ul>
        """
    ))
    """
}
