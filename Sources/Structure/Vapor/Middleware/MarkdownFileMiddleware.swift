// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public struct MarkdownFileMiddleware: AsyncMiddleware {
    public let bundle: Bundle
    public let basePath: String
    public let directory: String

    private let shouldIncludeSubdirectories: Bool

    private let renderer: MarkdownDocumentRendering.Type

    /// Represents the minimum number of path components for a match.
    /// This is calculated via the number of directories supported in the `basePath` plus `1` for the slug.
    /// Note that if `shouldIncludeSubdirectories` is `true`, the count can be higher for a valid request.
    private var minimumPathComponentCount: Int {
        self.basePath.split(separator: "/").count + 1
    }

    public init(
        bundle: Bundle,
        basePath: String,
        directory: String,
        shouldIncludeSubdirectories: Bool = false,
        renderer: MarkdownDocumentRendering.Type = MarkdownPage.self
    ) {
        self.basePath = basePath
        self.bundle = bundle
        self.directory = directory
        self.renderer = renderer
        self.shouldIncludeSubdirectories = shouldIncludeSubdirectories
    }

    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // First, validate if our middleware should respond to this request.
        guard self.shouldRespond(to: request) else {
            return try await next.respond(to: request)
        }

        // Strip our base path from the beginning of the request path to get our article slug.
        let slug = {
            guard !self.basePath.isEmpty else {
                return request.url.path.trimmingSlashes()
            }

            return request.url.path.replacingOccurrences(of: "^/\(self.basePath)/", with: "", options: .regularExpression)
        }()

        // Attempt to fetch our article, then render within the given page.
        do {
            let page = try request.resources.markdownPage(self.renderer, slug: slug, bundle: self.bundle, directory: self.directory)
            return try await request.render(page).encodeResponse(for: request)
        } catch ResourceError.fileNotFound where request.application.environment.isRelease {
            return try await next.respond(to: request)
        } catch {
            return try await next.respond(to: request)
        }
    }

    private func shouldRespond(to request: Request) -> Bool {
        // First, split our request path into its components.
        let pathComponents = request.url.path.split(separator: "/")

        // If there are no path components, it implies a request at the root, which is not supported by this middleware.
        guard pathComponents.count > 0 else {
            return false
        }

        // The first path component MUST match our base path, unless our base path is the root.
        guard self.basePath.isEmpty || pathComponents.first == Substring(self.basePath) else {
            return false
        }

        if self.shouldIncludeSubdirectories {
            return pathComponents.count > self.minimumPathComponentCount
        } else {
            return pathComponents.count == self.minimumPathComponentCount
        }
    }
}

// MARK: - Extensions

public extension Application {
    func enableMarkdownFileMiddleware(
        bundle: Bundle,
        basePath: String = "",
        directory: String = "pages",
        shouldIncludeSubdirectories: Bool = false,
        renderer: MarkdownDocumentRendering.Type = MarkdownPage.self
    ) {
        self.middleware.use(MarkdownFileMiddleware(
            bundle: bundle,
            basePath: basePath,
            directory: directory,
            shouldIncludeSubdirectories: shouldIncludeSubdirectories,
            renderer: renderer
        ))
    }
}

private extension String {
    func matches(_ pattern: String, expectedMatches: Int? = nil) throws -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: self, range: range)

        if let expectedMatches = expectedMatches {
            return matches.count == expectedMatches
        } else {
            return matches.count > 0
        }
    }
}
