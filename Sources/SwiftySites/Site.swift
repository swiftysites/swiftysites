import Foundation

/// Defines a site in terms of its content types.
///
/// Rather than using this struct directly to use one of the its aliases like ``BasicSite`` or ``BasicBlog``.
/// Or create your own custom alias based on the multi-content aliases like ``SiteA`` or ``SiteB``.
///
/// Example:
///
/// ```swift
/// typealias MySite = SiteB<Page, Post>
/// ```
///
public struct Site<A: Content, B: Content, C: Content, D: Content, E: Content> {

    /// The site's configuration parameters.
    public let config: SiteConfig

    /// Content instances for the corresponding content type.
    ///
    /// You can specify up to five content types.
    ///
    public internal(set) var contentA: [A], contentB: [B], contentC: [C], contentD: [D], contentE: [E]

    /// Templates to be applied to content.
    let templates: [Template]
}

private extension Site {

    func write(_ string: String, _ file: URL) {
        let currentFolder = Self.currentFolder
        let wwwFolder = currentFolder.appendingPathComponent("www")
        let newFile = wwwFolder.appendingPathComponent(file.relativePath)
        let newDir = newFile.deletingLastPathComponent()
        do {
            try FileManager.default.createDirectory(at: newDir, withIntermediateDirectories: true)
        } catch {
            fatalError("Could not create directories at \(newDir.path).")
        }
        do {
            try string.write(to: newFile, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            fatalError("Could not write to \(newFile.path).")
        }
    }

    static func findAncestor(containing markerFile: String, from startingUrl: URL) -> URL? {
        let markerURL = startingUrl.appendingPathComponent(markerFile)
        if FileManager.default.fileExists(atPath: markerURL.path) {
            return startingUrl
        } else if startingUrl.pathComponents.count == 1 {
            return .none
        } else {
            return findAncestor(containing: markerFile, from: startingUrl.deletingLastPathComponent())
        }
    }

    static var currentFolder: URL {
        let fm = FileManager.default
        let workingDirectory = URL(fileURLWithPath: fm.currentDirectoryPath)
        return findAncestor(containing: "Package.swift", from: workingDirectory) ?? workingDirectory
    }

    /// Copies over the contents of the static folder.
    func cleanWWW() {
        let fm = FileManager.default
        let wwwFolder = Self.currentFolder.appendingPathComponent("www")
        guard fm.fileExists(atPath: wwwFolder.path) else {
            return
        }
        do {
            try fm.removeItem(at: wwwFolder)
        } catch {
            fatalError("Could not remove '\(wwwFolder.path)'.")
        }
    }

    /// Copies over the contents of the static folder.
    func syncStatic() {
        let fm = FileManager.default
        let currentFolder = Self.currentFolder
        let wwwFolder = currentFolder.appendingPathComponent("www")
        let staticFolder = currentFolder.appendingPathComponent("static")

        var contents = [URL]()
        guard let enumerator = fm.enumerator(at: staticFolder, includingPropertiesForKeys: [.isRegularFileKey], options: [.producesRelativePathURLs, .skipsHiddenFiles]) else {
            fatalError()
        }
        for case let url as URL in enumerator {
            guard let attributes = try? url.resourceValues(forKeys: [.isRegularFileKey]), let isRegularFile = attributes.isRegularFile else {
                fatalError()
            }
            if isRegularFile {
                contents.append(url)
            }
        }

        contents.forEach { content in
            let destination = wwwFolder.appendingPathComponent(content.relativePath)
            let newDir = destination.deletingLastPathComponent()
            do {
                try fm.createDirectory(at: newDir, withIntermediateDirectories: true)
            } catch {
                fatalError("Could not create directories at '\(newDir.path)'.")
            }

            if fm.fileExists(atPath: destination.path) {
                do {
                    try fm.removeItem(at: destination)
                } catch {
                    fatalError("Could not remove item  '\(destination.path)'.")
                }
            }

            let source = URL(fileURLWithPath: content.path)
            guard let _ = try? fm.copyItem(at: source, to: destination) else {
                fatalError("Could not copy file at '\(source.path)' to '\(destination.path)'.")
            }
        }
    }

    func render<Z: Content>(_ content: [Z], files: inout [URL]) {
        content
        .forEach { content in
            templates
            .filter {
                (Z.self == A.self && $0.applyA != nil) ||
                (Z.self == B.self && $0.applyB != nil) ||
                (Z.self == C.self && $0.applyC != nil) ||
                (Z.self == D.self && $0.applyD != nil) ||
                (Z.self == E.self && $0.applyE != nil)
            }
            .filter {
                content.path.matchesExactly($0.match)
            }
            .filter {
                guard let exclude = $0.exclude else {
                    return true
                }
                return !content.path.matchesExactly(exclude)
            }
            .forEach { template in
                let fileWithoutExt = URL(fileURLWithPath: content.path).deletingPathExtension()
                let fileWithIndex: URL
                if let index = template.index {
                    fileWithIndex = fileWithoutExt.appendingPathComponent(index)
                } else {
                    if fileWithoutExt.pathComponents.count > 1 {
                        fileWithIndex = fileWithoutExt
                    } else {
                        fileWithIndex = fileWithoutExt.appendingPathComponent(Template.defaultIndex).appendingPathExtension(Template.defaultSuffix)
                    }
                }
                let newFile: URL
                if let suffix = template.suffix {
                    newFile = fileWithIndex.appendingPathExtension(suffix)
                } else {
                    newFile = fileWithIndex
                }

                let originalMapFile = config.url.appendingPathComponent(newFile.path)
                let mapFile: URL
                if originalMapFile.lastPathComponent == "\(Template.defaultIndex).\(Template.defaultSuffix)" {
                    // Correct all index.html
                    mapFile = originalMapFile.deletingLastPathComponent()
                } else {
                    mapFile = originalMapFile
                }
                if !files.contains(mapFile) {
                    files.append(mapFile)
                }

                let output = Z.self == A.self
                    ? template.applyA!(self, content as! A)
                    : Z.self == B.self
                    ? template.applyB!(self, content as! B)
                    : Z.self == C.self
                    ? template.applyC!(self, content as! C)
                    : Z.self == D.self
                    ? template.applyD!(self, content as! D)
                    : template.applyE!(self, content as! E)

                write(output, newFile)
                // TODO: check if we are replacing a directory with a file, in which case we need to manually delete beforehand
            }
        }
    }
}

public extension Site {

    /// Use to test regular expresions against path strings.
    ///
    /// Returns whether the regular expression matches the path exactly.
    ///
    /// - Parameters:
    ///   - path: The path that the regular expression will be tested against.
    ///   - regex: A regular expression to be matched against the entirety of the path.
    ///
    /// Example.
    ///
    /// ```swift
    /// Site.matches(path: "/tag/programming", regex: #"/tag/\w*"#) // true
    /// ```
    ///
    static func matches(path: String, regex: String) -> Bool {
        path.matchesExactly(regex)
    }

    /// Default and only initializer to create _Site_ instances.
    ///
    /// - Parameters:
    ///   - config: Your site's configuration object.
    ///   - contentA: Initial items of your first content type.
    ///   - contentB: Initial items of your second content type.
    ///   - contentC: Initial items of your third content type.
    ///   - contentD: Initial items of your fourth content type.
    ///   - contentE: Initial items of your fifth content type.
    ///   - templates: Templates will be applied at render time.
    ///   - generators: Generators are applied during initialization and the generated content will be appended to the user-specified content.
    ///
    init(
        _ config: SiteConfig,
        contentA: [A],
        contentB: [B] = [],
        contentC: [C] = [],
        contentD: [D] = [],
        contentE: [E] = [],
        templates: [Template],
        generators: [Generator] = []
    ) {
        self.init(
            config: config,
            contentA: contentA,
            contentB: contentB,
            contentC: contentC,
            contentD: contentD,
            contentE: contentE,
            templates: templates
        )

        generators.forEach {
            if let generate = $0.generateA {
                self.contentA += generate(self)
            } else if let generate = $0.generateB {
                self.contentB += generate(self)
            } else if let generate = $0.generateC {
                self.contentC += generate(self)
            } else if let generate = $0.generateD {
                self.contentD += generate(self)
            } else if let generate = $0.generateE {
                self.contentE += generate(self)
            }
        }
    }

    /// The site's build date formatted for use in an RSS feed.
    var buildDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
        return dateFormatter.string(from: Date()) // // Mon, 02 Jan 2006 15:04:05 -0700
    }

    /// Generate the static site writing the output to the _www_ folder.
    ///
    /// All parameters can also be specified as command-line arguments. The function's explicit parameters take precedence over values specified on the command line.
    ///
    /// Invoke your executable with `swift run MySite --help` for a list of available flags.
    ///
    /// - Parameters:
    ///  - clean: Deletes the `www` folder entirely before rendering. Defaults to false (will not delete the `www` folder).
    ///  - skipSitemap: Does not generate a sitemap file. Defaults to false (will generate a sitemap).
    ///  - skipStatic: Avoids copying the contents of the `static` folder into the `www` folder. Defaults to false (will copy static).
    ///  
    @discardableResult func render(clean: Bool? = nil, skipSitemap: Bool? = nil, skipStatic: Bool? = nil) -> SiteMap {

        let options = RenderCommand.parseOrExit()
        let clean = clean ?? options.clean
        let skipSitemap = skipSitemap ?? options.skipSitemap
        let skipStatic = skipStatic ?? options.skipStatic

        var sitemapUrls = [URL]()

        if clean {
            cleanWWW()
        }

        if !skipStatic {
            syncStatic()
        }

        render(contentA, files: &sitemapUrls)
        render(contentB, files: &sitemapUrls)
        render(contentC, files: &sitemapUrls)
        render(contentD, files: &sitemapUrls)
        render(contentE, files: &sitemapUrls)

        let sitemap = SiteMap(urls: sitemapUrls, generatesSitemapFile: !skipSitemap)

        if let sitemapFile = sitemap.sitemapFile {
            write(sitemap.xmlContents, sitemapFile)
        }

        return sitemap
    }
}
