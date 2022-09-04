// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public protocol ApplicationDelegate: AppConfiguring {
    var app: Application { get }

    init(_ app: Application)
}

// MARK: - Supporting Types

public protocol AppConfiguring {
    func configure(_ app: Application) throws
}

// MARK: - Extensions

public extension ApplicationDelegate {
    init() throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        self.init(Application(env))
    }

    func run() throws {
        defer { self.app.shutdown() }

        try self.configure(self.app)
        try self.app.run()
    }
}
