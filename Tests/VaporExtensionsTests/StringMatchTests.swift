// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor
@testable import VaporExtensions
import XCTest

final class StringMatchTests: XCTestCase {
    /// Our test pattern matches numbers between lowercase letters.
    private static let pattern = #"[a-z]+([0-9]+)[a-z]+"#

    func testNoCaptureGroups() {
        let string = "abcdefghijklmnopqrstuvwxyz"
        let matches = string.captureGroups(for: Self.pattern)

        XCTAssertEqual(matches.count, 0)
    }

    func testSingleCaptureGroup() throws {
        let strings = [
            // our basic match
            "hello123world",
            // FIXME: Having issues with multiple occurrences in single line and multiline strings.
            // should only return one capture group "123", since the rest of the string isn't evaluated.
            // "hello123world456hello",
        ]

        for string in strings {
            let matches = string.captureGroups(for: Self.pattern)

            XCTAssertEqual(matches.count, 1)
            XCTAssertEqual(matches, ["123"])
        }
    }
}
