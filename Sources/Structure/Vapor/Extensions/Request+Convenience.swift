// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public extension Request {
    var environment: Environment {
        self.application.environment
    }

    var preferredScheme: URI.Scheme {
        switch self.environment {
        case .local:
            return .http
        default:
            return .https
        }
    }

    var host: String? {
        self.headers.first(name: .host)
    }

    var canonicalURL: String? {
        guard let scheme = self.preferredScheme.value,
              let host = self.headers.first(name: .host) else {
            return nil
        }

        return "\(scheme)://\(host)\(self.url.path)"
    }
}
