// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation
import Vapor

public enum ApplicationError: LocalizedError {
    case invalidEnvironment(Environment)
    
    public var errorDescription: String? {
        switch self {
        case let .invalidEnvironment(environment):
            return "Invalid environment '\(environment)'."
        }
    }
}
