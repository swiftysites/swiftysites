//public func makeRSSTemplate<each C: Content>(site: Site<repeat each C>) -> Template<Page> {
//    return Template<Page>(#"^/$"#, suffix: "xml") { page in
//    """
//    <div>
//    \(page.$content)
//    \(site.contentA.reduce("") {
//        """
//        \($0)
//        \($1.title)
//        """
//    })
//    </div>
//    """
//    }
//}
