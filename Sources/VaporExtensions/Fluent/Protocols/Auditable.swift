// Copyright © 2022 Brian Drelling. All rights reserved.

import Fluent
import Foundation

public protocol Auditable: Model {
    var createDate: Date? { get set }
    var updateDate: Date? { get set }
    var deleteDate: Date? { get set }
}

// MARK: - Extensions

public extension FieldKey {
    static let createDate: Self = "create_date"
    static let updateDate: Self = "update_date"
    static let deleteDate: Self = "delete_date"
}
