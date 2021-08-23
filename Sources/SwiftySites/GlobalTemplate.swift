extension Site {

    public struct GlobalTemplate {
        let match: String
        let suffix: String
        let apply: (Site, A?, B?) -> String
        
        public init(match: String, suffix: String, apply: @escaping (Site, A?, B?) -> String) {
            self.match = match
            self.suffix = suffix
            self.apply = apply
        }
    }
}
