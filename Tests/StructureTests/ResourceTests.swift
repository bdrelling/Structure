// Copyright © 2022 Brian Drelling. All rights reserved.

@testable import Structure
import XCTest

final class ResourceTests: XCTestCase {
    func testResourcesExist() {
        let path = StructureCDNMiddleware.bundle.path(forResource: "css/structure/structure.css", ofType: nil, inDirectory: nil)
        let paths = StructureCDNMiddleware.bundle.paths(forResourcesOfType: "css", inDirectory: "css")

        print(path)
        print(paths)

        XCTAssertGreaterThan(paths.count, 0)
    }
}
