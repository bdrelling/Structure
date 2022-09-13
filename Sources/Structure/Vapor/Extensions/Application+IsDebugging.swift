// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public extension Application {
    static var isDebugging: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
