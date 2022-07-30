// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public extension Parameters {
    func get<T>(_ parameter: PathParameter, as type: T.Type = T.self) -> T? where T: LosslessStringConvertible {
        self.get(parameter.name, as: type)
    }

    func get<P, T>(_ parameter: P, as type: T.Type = T.self) -> T? where P: RawRepresentable, P.RawValue == PathParameter, T: LosslessStringConvertible {
        self.get(parameter.rawValue.name, as: type)
    }
}
