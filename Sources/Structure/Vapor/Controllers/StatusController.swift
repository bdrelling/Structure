// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public struct StatusController {
    public init() {}
}

extension StatusController: RouteCollection {
    public func boot(routes: RoutesBuilder) throws {
        routes.get("") { _ in
            true
        }
    }
}
