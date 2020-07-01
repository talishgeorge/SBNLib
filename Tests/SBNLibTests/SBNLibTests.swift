import XCTest
@testable import SBNLib

final class SBNLibTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SBNLib().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
