// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation

public struct PathParameter: Equatable {
    public var name: String
}

extension PathParameter: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        self.name = stringLiteral
    }
}
