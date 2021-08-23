import Foundation

/// Defines a site in terms of its content types
public struct Site<A: Content, B: Content> {

    public let config: SiteConfig
    public let contentA: [A], contentB: [B]
    let globalTemplates: [GlobalTemplate]
    let templatesA: [Template<A>], templatesB: [Template<B>]

    var globalTemplate: GlobalTemplate.Type {
        GlobalTemplate.self
    }

    public init(
        config: SiteConfig,
        contentA: [A], contentB: [B],
        globalTemplates: [GlobalTemplate],
        templatesA: [Template<A>], templatesB: [Template<B>]
    ) {
        self.config = config
        self.contentA = contentA
        self.contentB = contentB
        self.globalTemplates = globalTemplates
        self.templatesA = templatesA
        self.templatesB = templatesB
    }

    private func write(_ string: String, _ file: URL) {
        let path = FileManager.default.currentDirectoryPath
        let newFile = URL(fileURLWithPath: path).appendingPathComponent("www").appendingPathComponent(file.relativePath)
        let newDir = newFile.deletingPathExtension().deletingLastPathComponent()
        do {
            try FileManager.default.createDirectory(at: newDir, withIntermediateDirectories: true)
        } catch {
            print("ERROR: Could not create directories at \(newDir.path)")
        }
        do {
            try string.write(to: newFile, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("ERROR: Could not write to \(newFile.path)")
        }
    }

    @discardableResult public func render() -> Self {
        apply(contentA, templatesA)
        apply(contentB, templatesB)
        contentA
        .forEach { content in
            globalTemplates
            .filter {
                content.file.path.matchesExactly($0.match)
            }
            .forEach { template in
                write(
                    template.apply(self, content, .none),
                    content.file.deletingPathExtension().appendingPathComponent("index").appendingPathExtension(template.suffix)
                )
            }
        }
        contentB
        .forEach { content in
            globalTemplates
            .filter {
                content.file.path.matchesExactly($0.match)
            }
            .forEach { template in
                write(
                    template.apply(self, .none, content),
                    content.file.deletingPathExtension().appendingPathComponent("index").appendingPathExtension(template.suffix)
                )
            }
        }
        return self
    }

    private func apply<C: Content>(_ contentItems: [C], _ templates: [Template<C>]) {
        contentItems
        .filter {
            !$0.globalTemplateOnly
        }
        .forEach { content in
            templates.forEach { template in
                write(
                    template.apply(config, content),
                    content.file.deletingPathExtension().appendingPathComponent("index").appendingPathExtension(template.suffix)
                )
            }
        }
    }
}
