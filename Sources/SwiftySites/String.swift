extension String {

    /// Usage: `"/hello".matchesExactly(#"^/hello$"#)` or in some cases simply `"/hello".matchesExactly("/hello")`.
    func matchesExactly(_ regularExpression: String) -> Bool {
        guard let range = range(of: regularExpression, options: .regularExpression) else {
            return false
        }
        return range.lowerBound == self.indices.startIndex && range.upperBound == self.indices.endIndex
    }
}
