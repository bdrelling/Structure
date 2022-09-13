// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public extension PathComponent {
    static func parameter(_ parameter: PathParameter) -> PathComponent {
        .parameter(parameter.name)
    }

    static func parameter<T>(_ parameter: T) -> PathComponent where T: RawRepresentable, T.RawValue == PathParameter {
        .parameter(parameter.rawValue.name)
    }
}
