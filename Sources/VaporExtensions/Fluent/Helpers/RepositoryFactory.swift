// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public final class RepositoryFactory {
    public let request: Request

    public init(request: Request) {
        self.request = request
    }
}

// MARK: - Extensions

public extension Request {
    var repositories: RepositoryFactory {
        .init(request: self)
    }
}
