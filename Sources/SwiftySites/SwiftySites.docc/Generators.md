# Content generators

Use content generators to dynamically generate content items that would consume too much time if declared manually. 

You create ``Site/Generator`` instances using the ``Site/generatorA(generate:)`` family of functions.

## Tags (Example)

Consider the ``BasicBlog`` site definition with first content type ``Page`` and second content type ``Post``.

We can declare a generator for the third content type ``TagPage`` which will produce one content item for each tag appearing in any of the blog's posts.

```swift
let tagGenerator = BasicBlog.generatorC { site in
    site.contentB.tags.map { tag in
        TagPage("/tags/\(tag)", tag: tag)
    }
}
```

Don't forget to include it when calling ``Site/init(_:contentA:contentB:contentC:contentD:contentE:templates:generators:)``. The generated content will be part of the site definition right after initialization.
