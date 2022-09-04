// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

extension Request {
    static let subdomainRegex = #"^([a-z0-9|-]+)\.[a-z0-9|-]+\.[a-z]+"#

    var host: String? {
        self.headers.first(name: .host)
    }

    public var subdomain: String? {
        self.host?.firstCaptureGroup(for: Self.subdomainRegex)
    }
}
