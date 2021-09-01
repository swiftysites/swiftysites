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
public struct Site<A: Content, B: Content> {

    /// The site's configuration parameters.
    public let config: SiteConfig

    /// Content instances for the corresponding content type.
    public let contentA: [A], contentB: [B]

    /// Templates to be applied to content.
    let templates: [Template]

    /// Default and only initializer to crete _Site_ instances.
    public init(
        _ config: SiteConfig,
        contentA: [A],
        contentB: [B] = [],
        templates: [Template]
    ) {
        self.config = config
        self.contentA = contentA
        self.contentB = contentB
        self.templates = templates
    }

    private func write(_ string: String, _ file: URL) {
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

    private static func findAncestor(containing markerFile: String, from startingUrl: URL) -> URL? {
        let markerURL = startingUrl.appendingPathComponent(markerFile)
        if FileManager.default.fileExists(atPath: markerURL.path) {
            return startingUrl
        } else if startingUrl.pathComponents.count == 1 {
            return .none
        } else {
            return findAncestor(containing: markerFile, from: startingUrl.deletingLastPathComponent())
        }
    }

    private static var currentFolder: URL {
        let fm = FileManager.default
        let workingDirectory = URL(fileURLWithPath: fm.currentDirectoryPath)
        return findAncestor(containing: "Package.swift", from: workingDirectory) ?? workingDirectory
    }

    /// Copies over the contents of the static folder.
    private func cleanWWW() {
        let wwwFolder = Self.currentFolder.appendingPathComponent("www")
        do {
            try FileManager.default.removeItem(at: wwwFolder)
        } catch {
            fatalError("Could not remove '\(wwwFolder.path)'.")
        }
    }

    /// Copies over the contents of the static folder.
    private func syncStatic() {
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

    func render<C: Content>(_ content: [C], files: inout [URL]) {
        content
        .forEach { content in
            templates
            .filter {
                (C.self == A.self && $0.applyA != nil) || (C.self == B.self && $0.applyB != nil)
            }
            .filter { content.file.path.matchesExactly($0.match) }
            .filter {
                guard let exclude = $0.exclude else {
                    return true
                }
                return !content.file.path.matchesExactly(exclude)
            }
            .forEach { template in
                let fileWithoutExt = content.file.deletingPathExtension()
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

                let originalMapFile = config.baseURL.appendingPathComponent(newFile.path)
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

                let output = C.self == A.self
                    ? template.applyA!(self, content as! A)
                    : template.applyB!(self, content as! B)
                write(output, newFile)
                // TODO: check if we are replacing a directory with a file, in which case we need to manually delete beforehand
            }
        }
    }

    /// Generate the static site writing the output to the _www_ folder.
    @discardableResult public func render(clean: Bool? = nil, skipSitemap: Bool? = nil) -> SiteMap {

        let options = RenderCommand.parseOrExit()
        let clean = clean ?? options.clean
        let skipSitemap = skipSitemap ?? options.skipSitemap

        var sitemapUrls = [URL]()

        if clean {
            cleanWWW()
        }

        syncStatic()

        render(contentA, files: &sitemapUrls)
        render(contentB, files: &sitemapUrls)

        let sitemap = SiteMap(urls: sitemapUrls, generatesSitemapFile: !skipSitemap)

        if let sitemapFile = sitemap.sitemapFile {
            write(sitemap.xmlContents, sitemapFile)
        }

        return sitemap
    }
}

/// Use to define a site type with only one content type.
///
/// Example:
///
/// ```swift
/// typealias MySite = SiteA<Page>
/// ```
///
public typealias SiteA<A: Content> = Site<A, Never>

/// Use to define a site type with two content type.
///
/// Example:
///
/// ```swift
/// typealias MySite = SiteB<Page, Post>
/// ```
///
public typealias SiteB<A: Content, B: Content> = Site<A, B>
