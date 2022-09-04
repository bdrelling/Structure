// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public extension Request {
    internal static let subdomainFromHostnameRegex = #"^([a-zA-Z0-9\-]+)\.[a-zA-Z0-9\-\.:]*[0-9]{0,5}"#

    var host: String? {
        self.headers.first(name: .host)
    }

    var subdomain: String? {
        self.host?.firstCaptureGroup(for: Self.subdomainFromHostnameRegex)
    }
}
