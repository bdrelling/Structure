// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public struct WrappedContent<T>: Content where T: Codable {
    public let content: T?

    public init(_ content: T?) throws {
        if let content = content {
            self.content = content
        } else {
            throw Abort(.notFound)
        }
    }
}
