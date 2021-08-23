/// Usage: "hello".matchesExactly(#"^hello$"#)
extension String {
    func matchesExactly(_ regularExpression: String) -> Bool {
        guard let range = range(of: regularExpression, options: .regularExpression) else {
            return false
        }
        return range.lowerBound == self.indices.startIndex && range.upperBound == self.indices.endIndex
    }
}
