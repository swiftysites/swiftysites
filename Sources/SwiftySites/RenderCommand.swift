import ArgumentParser

struct RenderCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "swift run",
        abstract: """
        This program generates the site defined in main.js using the SwiftySites library.
        """,
        discussion: """
        Run this command-line tool to generate your static site from Swift sources.
        """,
        version: "SwiftySites v1.0.0",
        shouldDisplay: true
    )

    @Flag(name: .shortAndLong, help: "Clears the 'www' folder before rendering.")
    var clean = false

    @Flag(name: .shortAndLong, help: "Avoids generating a 'sitemap.xml' file at the root.")
    var skipSitemap = false
}
