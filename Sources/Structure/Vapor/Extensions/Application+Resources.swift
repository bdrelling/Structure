// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public extension Application {
    var resources: ResourceManager {
        /// While debugging (ie. running the server locally), no files are cached, which allows the files to be edited while the server is running.
        let isDebugging = self.environment == .local
        let manager = self.storage[ResourceManagerStorageKey.self] ?? .init(shouldCache: isDebugging)

        if self.storage[ResourceManagerStorageKey.self] == nil {
            self.storage[ResourceManagerStorageKey.self] = manager
        }

        return manager
    }
}

// MARK: - Supporting Types

public struct ResourceManagerStorageKey: StorageKey {
    public typealias Value = ResourceManager
}

// MARK: - Extensions

public extension Request {
    var resources: ResourceManager {
        self.application.resources
    }
}
