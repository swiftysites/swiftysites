import XCTest
@testable import SwiftySites

final class SwiftySitesTests: XCTestCase {
    func testExample() throws {
        XCTAssert("hello".matchesExactly(#"^hello$"#))
    }
}
