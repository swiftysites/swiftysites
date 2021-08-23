import Foundation

extension Never: Content {
    public var file: URL {
        fatalError()
    }
    
    public var markdown: String {
        fatalError()
    }
}
