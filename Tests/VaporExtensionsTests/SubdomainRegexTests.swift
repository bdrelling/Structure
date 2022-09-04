// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor
@testable import VaporExtensions
import XCTest

final class SubdomainRegexTests: XCTestCase {
    func testNoMatches() {
        let string = "briandrelling.com"
        let matches = string.captureGroups(for: Request.subdomainFromHostnameRegex)

        XCTAssertEqual(matches.count, 0)
    }

    func testSingleMatch() throws {
        let strings = [
            "www.briandrelling.com",
            "www.briandrelling.co.uk",
            "www.briandrelling.local:8080",
        ]

        for string in strings {
            let matches = string.captureGroups(for: Request.subdomainFromHostnameRegex)

            XCTAssertEqual(matches.count, 1)
            XCTAssertEqual(matches, ["www"])
        }
    }
}
