import Foundation

extension Array {
    
    func apply<C: Content>(_ contentItems: [C], baseURL: URL) -> [URL] where Element == Template<C> {
        flatMap { t in
            t.apply(contentItems, baseURL: baseURL)
        }
    }
}
