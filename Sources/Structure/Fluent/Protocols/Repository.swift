// Copyright © 2022 Brian Drelling. All rights reserved.

import Fluent
import Vapor

public protocol Repository {
    associatedtype Model: FluentKit.Model

    typealias ModelID = Model.IDValue

    var database: Database { get }

    init(application: Application) throws
    init(request: Request) throws

    func query() -> QueryBuilder<Model>
    func query(id: ModelID) -> QueryBuilder<Model>

    func get() async throws -> [Model]
    func get(id: ModelID) async throws -> Model?

    @discardableResult
    func create(_ model: Model) async throws -> Model

    @discardableResult
    func update(_ model: Model) async throws -> Model

    // TODO: Should this (and maybe get, create, update, etc.) be in its own protocol, to avoid default behavior?
    func delete(id: ModelID) async throws
}

// MARK: - Supporting Types

public enum RepositoryError: Error {
    case invalidRequest(reason: String? = nil)
    case modelNotFound(id: String)
    case modelIDNotFound
}

// MARK: - Extensions

public extension Repository {
    func query() -> QueryBuilder<Model> {
        Model.query(on: self.database)
    }

    func query(id: ModelID) -> QueryBuilder<Model> {
        self.query()
            .filter(\._$id == id)
    }

    func get() async throws -> [Model] {
        try await self.query().all()
    }

    func get(id: ModelID) async throws -> Model? {
        try await self.query(id: id)
            .first()
    }

    @discardableResult
    func create(_ model: Model) async throws -> Model {
        try await model.create(on: self.database)

        return model
    }

    @discardableResult
    func update(_ model: Model) async throws -> Model {
        try await model.update(on: self.database)

        return model
    }

    @discardableResult
    func createOrUpdate(_ model: Model) async throws -> Model {
        try await model.save(on: self.database)

        return model
    }

    func delete(id: ModelID) async throws {
        guard let model = try await self.query(id: id).first() else {
            throw RepositoryError.modelNotFound(id: String(describing: id))
        }

        try await model.delete(on: self.database)
    }
}
