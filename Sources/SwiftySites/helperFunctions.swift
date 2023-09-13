import Foundation

/// Copies over the contents of the static folder.
func syncStatic() {
    let fm = FileManager.default
    let currentFolder = currentFolder
    let wwwFolder = currentFolder.appendingPathComponent("www")
    let staticFolder = currentFolder.appendingPathComponent("static")
    
    var contents = [URL]()
    guard let enumerator = fm.enumerator(
        at: staticFolder,
        includingPropertiesForKeys: [
            // .isRegularFileKey, // Does not work on Linux.
            .isDirectoryKey
        ],
        options: [
            // .producesRelativePathURLs, // Does not work on Linux.
        ]
    ) else {
        fatalError()
    }
    
    for case let url as URL in enumerator {
        guard let attributes = try? url.resourceValues(forKeys: [.isDirectoryKey]), let isDirectory = attributes.isDirectory else {
            fatalError()
        }
        
        if !isDirectory {
            // This is to work around not having `.producesRelativePathURLs` on Linux.
            let relativePath = url.pathComponents.suffix(from: staticFolder.pathComponents.count).joined(separator: "/")
            let relativeURL = URL(fileURLWithPath: relativePath, relativeTo: staticFolder)
            
            // Append relative URL
            contents.append(relativeURL)
        }
    }
    
    contents.forEach { source in
        let destination = wwwFolder.appendingPathComponent(source.relativePath)
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
        
        //let source = URL(fileURLWithPath: content.path)
        guard let _ = try? fm.copyItem(at: source, to: destination) else {
            fatalError("Could not copy file at '\(source.path)' to '\(destination.path)'.")
        }
    }
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

/// The site's build date formatted for use in an RSS feed.
public func rssTimestamp() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
    return dateFormatter.string(from: Date.now) // // Mon, 02 Jan 2006 15:04:05 -0700
}

func findAncestor(containing markerFile: String, from startingUrl: URL) -> URL? {
    let markerURL = startingUrl.appendingPathComponent(markerFile)
    if FileManager.default.fileExists(atPath: markerURL.path) {
        return startingUrl
    } else if startingUrl.pathComponents.count == 1 {
        return .none
    } else {
        return findAncestor(containing: markerFile, from: startingUrl.deletingLastPathComponent())
    }
}

var currentFolder: URL {
    let fm = FileManager.default
    let workingDirectory = URL(fileURLWithPath: fm.currentDirectoryPath)
    return findAncestor(containing: "Package.swift", from: workingDirectory) ?? workingDirectory
}

/// Copies over the contents of the static folder.
func cleanWWW() {
    let fm = FileManager.default
    let wwwFolder = currentFolder.appendingPathComponent("www")
    guard fm.fileExists(atPath: wwwFolder.path) else {
        return
    }
    do {
        try fm.removeItem(at: wwwFolder)
    } catch {
        fatalError("Could not remove '\(wwwFolder.path)'.")
    }
}


func writeFile(_ string: String, _ file: URL) {
    let currentFolder = currentFolder
    let wwwFolder = currentFolder.appendingPathComponent("www")
    let newFile = wwwFolder.appendingPathComponent(file.relativePath) // TODO: Try `file.path` instead.
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
