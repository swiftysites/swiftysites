import SwiftySites

let basic_pageTemplate = Template<Page>(suffix: "html") {
    """
    \(basic_layoutTemplate($0, $1,
        top: """
        \(basic_fragmentTemplate($1))
        """
    ))
    """
}
