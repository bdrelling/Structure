// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public extension Request {
    var host: String? {
        self.headers.first(name: .host)
    }
}
