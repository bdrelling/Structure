// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public extension Environment {
    static let local: Self = .custom(name: "local")
}
