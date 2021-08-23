public struct Template<C: Content> {
    let suffix: String
    let apply: (SiteConfig, C) -> String
    
    public init(suffix: String, apply: @escaping (SiteConfig, C) -> String) {
        self.suffix = suffix
        self.apply = apply
    }
}
