import Foundation
import SwiftySites

let minimal_homePage = Page(
    globalTemplateOnly: true,
    file: URL(fileURLWithPath: "/"),
    title: "Home Page",
    markdown: """
    # Welcome
    
    This is the Home Page.
    
    """
)
