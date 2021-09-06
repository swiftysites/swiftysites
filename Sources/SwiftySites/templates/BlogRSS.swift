public let rssTemplate = BasicBlog.templateA(#"^/$"#, suffix: "xml") { site, page in
    """
    <div>
    \(page.$content)
    \(site.contentA.reduce("") {
        """
        \($0)
        \($1.title)
        """
    })
    </div>
    """
}
