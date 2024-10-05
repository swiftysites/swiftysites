# Getting Started

With SwiftySites you define your website in a Swift Package. The package needs to contain an executable target which will depend on the SwiftySites library.

When you declare your site you provide:

- A configuration containing your site's metadata like title and copyright notice.
- All of the content instances grouped by type. Each type may specify arbitrary metadata as well as markdown content.
- The templates to be applied to content instances to generate output like HTML.

## Example

Below is a short sample code for rendering a simple website. 

```swift
let config = SiteConfig(title: "My Site", productionUrl: URL(string: "https://swiftysites.dev")!)

// We define two articles.
let articles = [
    Article(path: "/articles/fish", title: "Fish" , body: "Many _fish_ in the sea."),
    .init(path: "/articles/turtles", title: "Turtles", body: "Turtles **all the way** down.")
]

// We declare a function to list all available articles.
func getArticleLinks() -> String {
    articles.map(\.title).joined()
}

// We also define two additional site pages.
let pages = [
    // The home page contains a list of articles.
    Page(path: "/", contents: "Home Page \(getArticleLinks())"),
    .init(path: "/about", contents: "About"),
]

// Both pages will be rendered using the following template.
let pageTemplates = [
    Template { (p: Page) in
        "<title>\(config.title)</title><body>\(p.contents)</body>"
    }
]

// For the articles we define an HTML and a JSON template.
let articleTemplates = [
    // The HTML template excludes articles which begin with "t" like "turtles".
    Template<Article>(exclude: #/\/articles\/t.*/#) { article in
        "Title: \(article.title); Text: \(article.$body)"
    },
    // The JSON template only applies to articles which begin with "t".
    Template(#/\/articles\/t.*/#, suffix: "json") { (a: Article) in
        "<h1>\(a.title)</h1><main>\(a.body)</main>"
    }
]

// The site includes all pages and articles, along with the corresponding template definitions.
let site = Site(config, content: (pages, articles), template: (pageTemplates, articleTemplates))

// We will render programmatically now but the following command tipically goes on main.swift.
let result = site.render(clean: true, skipSitemap: true, skipStatic: true)

result.urls
// [https://swiftysites.dev/, https://swiftysites.dev/about/, https://swiftysites.dev/articles/fish/, https://swiftysites.dev/articles/turtles/index.json]
```

When your executable runs, it will call the site's render method which will produce all of the static site's files.

## Using Xcode

You can edit, build and run your website Swift package using Xcode.

### Working Directory

For convenience make sure you set the working directory to where your `Package.swift` resides. This way the location of the `www` folder will be the same as when running from the command line.

To set your working directory within Xcode go to `"MySite" Scheme > "Edit Scheme…" > Run (Sidebar) > Options (Tab) > Working Directory > "Use custom working directory:"` and specify your package's root.

### Production Build

By default Xcode generates the development version of your site. To switch to production change your scheme to use `Release` configuration instead of the default Debug.

Command line builds also generate debug builds by default. To change this use the `-c` option and specify `release` as configuration.

```sh
swift run -c release
```

## Passing parameters

```sh
swift run -c release MySite --clean
```

Options passed directly to ``Site/render(clean:skipSitemap:skipStatic:)`` method override those specified on the command line.

To get all available options.

```sh
swift run MySite --help
```

To generate an auto-completion script.

```sh
swift run MySite --generate-completion-script zsh
```
