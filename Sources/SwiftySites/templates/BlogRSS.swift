public let rssTemplate = BlogSite.GlobalTemplate(match: #"/"#, suffix: "xml") { site, page, _ in
    """
    <div>
    \(page!.markdown)
    \(site.contentA.reduce("") {
        """
        \($0)
        \($1.title)
        """
    })
    </div>
    """
}
