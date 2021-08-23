# SwiftySites

Generate static sites from Markdown using Swift.

## Getting Started

Start by creating a folder for your site.

```sh
mkdir MySite
cd MySite
```

Initialize as an executable Swift Package.

```sh
swift package init --type executable
```

Edit your _package.swift_ to first set _macOS 11_ as the platform and to add _SwiftySites_ as a dependency to both package and target.

```swift
let package = Package(
    name: "MySite",
    platforms: [.macOS(.v11)],
    dependencies: [
        .package(url: "https://github.com/swiftysites/swiftysites.git", from: "1.0.0-beta.1")
    ],
    …
    targets: [
        .executableTarget(
            name: "MySite",
            dependencies: [.product(name: "SwiftySites", package: "swiftysites")]),
            
        …
    ]
    …
)

```

Populate your site with some content.

```sh
cat >> Sources/MySite/home.swift << EOF
import Foundation
import SwiftySites

let homePage = Page(
    globalTemplateOnly: true,
    file: URL(fileURLWithPath: "/"),
    title: "Home Page",
    markdown: """
    # Welcome
    
    This is the Home Page.
    
    """
)
EOF
```

And some templates.

```sh
cat >> Sources/MySite/homeTemplate.swift << EOF
import SwiftySites

let homeTemplate = BasicSite.GlobalTemplate(match: #"/"#, suffix: "html") { site, page, _ in
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
EOF
```

To tie it all together, let's define the site itself in _main.swift_.

```sh
rm Sources/MySite/main.swift

cat >> Sources/MySite/main.swift << EOF
import SwiftySites

BasicSite(
    config: .init(title: "My Site"),
    contentA: [homePage],
    contentB: [],
    globalTemplates: [homeTemplate],
    templatesA: [],
    templatesB: []
).render()
EOF
```

Tip: Check out the [Samples](Sources/Samples) folder for more examples on how to write and organize your content files.

Finally build and run your executable to generate your static site!

```sh
swift run
```

All the generated files will be in the _www_ folder.

Spin up a web server to publish your static site locally.

```sh
python -m http.server --directory www
```

Direct your browser to http://localhost:8000/index.html to see your site.
