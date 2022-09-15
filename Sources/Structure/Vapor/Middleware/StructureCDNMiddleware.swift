// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public struct StructureCDNMiddleware: AsyncMiddleware {
    private let validSubdirectories = [
        "css",
        "js",
    ]

    init() {}

    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard self.validSubdirectories.anySatisfy({ request.url.path.hasPrefix("/cdn/\($0)/") }) else {
            return try await next.respond(to: request)
        }

        // Strip "/cdn/" from the path.
        let path = request.url.path.replacingOccurrences(of: "/cdn/", with: "")

        // Attempt to stream the static file.
        return try await self.streamStaticFile(path: path, request: request)
    }

    private func streamStaticFile(path: String, request: Request) async throws -> Response {
        guard let path = Bundle.module.path(forResource: path, ofType: nil, inDirectory: nil) else {
            throw Abort(.notFound)
        }

        return request.fileio.streamFile(at: path)
    }
}

// MARK: - Extensions

public extension Application {
    func enableStructureCDN() {
        self.middleware.use(StructureCDNMiddleware())
    }
}

public extension Collection {
    func anySatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        for element in self {
            if try predicate(element) {
                return true
            }
        }

        return false
    }
}
