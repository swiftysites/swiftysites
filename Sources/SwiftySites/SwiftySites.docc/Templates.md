# Templates

Use templates to transform content items into the outputs that make up your website.

You create ``Site/Template`` instances using the ``Site/templateA(_:exclude:index:suffix:apply:)`` family of functions.

## Content templates

Match a specific content type and produce an entry point for a site.

Example.

```swift
let pageTemplate = BasicBlog.templateA(exclude: #"(/)|(/posts)"#) { site, page in baseLayout(site: site, page: page, main: """
<main>
    \(page.content)
</main>
""" ) }
```

Include all content templates when calling ``Site/init(_:contentA:contentB:contentC:contentD:contentE:templates:generators:)``. The templates will only be applied when calling ``Site/render(clean:skipSitemap:)``.

## Layout templates

Use them to define a common layout.

Example.

```swift
func baseLayout (site: BasicBlog, page: Page? = nil, post: Post? = nil, tagPage: TagPage? = nil, main: String) -> String { """
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <link rel="stylesheet" href="/assets/global.css" />
        <script src="/assets/highlight.js"></script>
        <title>\(site.config.title) | \(page?.title ?? post?.title ?? tagPage!.tag)</title>
    </head>
    <body>
        <header>
            \(navigationPartial(site, page))
        </header>
        \(main)
        <footer>
            <span>Made with  and <a href="https://github.com/swiftysites/swiftysites">SwiftySites</a>.</span>
        </footer>
    </body>
</html>
""" }
```

Usage.

```swift
let postsSectionTemplate = BasicBlog.templateA("/posts") { site, page in baseLayout(site: site, page: page, main: """
<main>
    \(page.content)
    <hr />
    <ul>
        \(site.contentB.reduce("") {
            $0 + """
            <li>
                <a href="\($1.path)">\($1.title)</a>
            </li>
            """
        })
    </ul>
</main>
""" ) }
```

## Partial templates

Use them to isolate fragments.

Example.

```swift
let postPartial = { (site: BasicBlog, post: Post) -> String in """
<article>
    <header>
        <h1><a href="\(post.path)">\(post.title)</a></h1>
        <div>\(post.author) on \(post.dateFormatted)</div>
    </header>
    <main>
    \(post.content)
    </main>
</article>
""" }
```

Usage.

```swift
let postTemplate = BasicBlog.templateB { site, post in baseLayout(site: site, post: post, main: """
<main>
    \(postPartial(site, post))
</main>
""" ) }
```
