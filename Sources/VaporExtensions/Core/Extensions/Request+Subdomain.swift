// Copyright © 2022 Brian Drelling. All rights reserved.

import KippleCore
import Vapor

public extension Request {
    static let subdomainRegex = #"([a-z0-9|-]+)\.[a-z0-9|-]+\.[a-z]+"#

    var host: String? {
        self.headers.first(name: .host)
    }

    var subdomain: String? {
        self.host?.firstMatch(for: Self.subdomainRegex)
    }
}
