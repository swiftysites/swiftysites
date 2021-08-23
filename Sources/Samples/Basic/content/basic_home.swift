import Foundation
import SwiftySites

let basic_homePage = Page(
    globalTemplateOnly: true,
    file: URL(fileURLWithPath: "/"),
    title: "Home Page",
    markdown: """
    # Welcome to the Home Page
    
    Find everything _you_ need **right here**.
    
    """
)
