import XCTest
import class Foundation.Bundle
@testable import SVGLibrary

final class SierpinskiSwiftTests: XCTestCase {
    
    func testMidpoint1() {
        let p1: Point = (1, 1)
        let p2: Point = (11, 11)
        XCTAssert(midpoint(p1, p2) == (6, 6))
    }
    
    func testMidpoint2() {
        let p1: Point = (23, 30)
        let p2: Point = (27, 32)
        XCTAssert(midpoint(p1, p2) == (25, 31))
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let binary = productsDirectory.appendingPathComponent("SierpinskiSwift")

        // run binary until it exits
        let process = Process()
        process.executableURL = binary

        process.launch()
        process.waitUntilExit()

        // compare created svg file against sample svg file
        let result = try String(contentsOfFile: "sample.svg")
        let expected = try String(contentsOfFile: "sierpinski.svg")

        XCTAssertEqual(result, expected)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
        ("testMidpoint1", testMidpoint1),
        ("testMidpoint2", testMidpoint2),
    ]
}
