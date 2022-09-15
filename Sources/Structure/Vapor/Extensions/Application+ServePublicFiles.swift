// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public extension Application {
    func servePublicFiles(from directory: String? = nil) {
        let directory = directory ?? self.directory.publicDirectory
        self.middleware.use(FileMiddleware(publicDirectory: directory))
    }
}
