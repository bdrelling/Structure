// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation
import PlotVapor
import Vapor

public final class ResourceManager {
    // MARK: Properties

    /// Whether or not our resources should be cached.
    private let shouldCache: Bool

    #warning("Is it possible that this cache could be too large?")
    #warning("Maybe split the cache into markdown, html, remote, etc?")
    /// A dictionary of local files that have been fetched previously and cached for performance optimization.
    /// Keys are slugs (eg. "some-file-name"),, values are the raw file contents.
    private var cachedLocalFiles: [String: String] = [:]

    /// A dictionary of remote files that have been fetched previously and cached for performance optimization.
    /// Keys are slugs (eg. "some-file-name"),, values are the raw file contents.
    private var cachedRemoteFiles: [String: String] = [:]

    // MARK: Initializers

    public init(shouldCache: Bool = true) {
        self.shouldCache = shouldCache
    }

    // MARK: Methods

    public func markdown(slug: String, bundle: Bundle, directory: String? = nil) throws -> MarkdownDocument {
        let text = try self.contentsOfFile(slug: slug, fileExtension: .markdown, bundle: bundle, directory: directory)

        return .init(slug: slug, text: text)
    }

    public func markdown(slug: String, from url: String, using client: Client) async throws -> MarkdownDocument {
        let text = try await self.contentsOfRemoteFile(slug: slug, from: url, using: client)

        return .init(slug: slug, text: text)
    }

    public func html(slug: String, bundle: Bundle, directory: String? = nil) throws -> String {
        try self.contentsOfFile(slug: slug, fileExtension: .html, bundle: bundle, directory: directory)
    }

    public func html(slug: String, from url: String, using client: Client) async throws -> String {
        try await self.contentsOfRemoteFile(slug: slug, from: url, using: client)
    }

    public func files(withExtension fileExtension: FileExtension, bundle: Bundle, directory: String? = nil) throws -> [MarkdownDocument] {
        try bundle.paths(forResourcesOfType: fileExtension.rawValue, inDirectory: directory)
            .compactMap { path in
                guard var slug = path.pathComponents.last?.description else {
                    return nil
                }

                // Replace underscores with hyphens and remove the file extension.
                slug = slug
                    .replacingOccurrences(of: "_", with: "-")
                    .replacingOccurrences(of: ".\(fileExtension.rawValue)", with: "")

                let text = try String(contentsOfFile: path)
                return .init(slug: slug, text: text)
            }
    }

    public func contentsOfFile(slug: String, fileExtension: FileExtension, bundle: Bundle, directory: String? = nil) throws -> String {
        // If the rest of our path contains slashes or file extensions, consider it invalid and throw an error.
        guard !slug.contains("/"), !slug.contains(fileExtension.rawValue) else {
            throw ResourceError.malformedSlug(slug)
        }

        // Our URL slugs use hyphens, but our local files use underscores.
        // We also remove leading and trailing slashes.
        let slug = slug
            .replacingOccurrences(of: "-", with: "_")
            .trimmingSlashes()

        // If we have a cached file, return it.
        if self.shouldCache, let cachedFile = self.cachedLocalFiles[slug] {
            return cachedFile
        }

        guard let path = bundle.path(forResource: slug, ofType: fileExtension.rawValue, inDirectory: directory) else {
            throw ResourceError.fileNotFound("\(slug).\(fileExtension.rawValue)")
        }

        let contents = try String(contentsOfFile: path)

        if self.shouldCache {
            self.cachedLocalFiles[slug] = contents
        }

        return contents
    }

    public func contentsOfRemoteFile(slug: String, from url: String, using client: Client) async throws -> String {
        // Our URL slugs use hyphens, but our local files use underscores.
        // We also remove leading and trailing slashes.
        let slug = slug
            .replacingOccurrences(of: "-", with: "_")
            .trimmingSlashes()

        // If we have a cached file, return it.
        if self.shouldCache, let cachedFile = self.cachedRemoteFiles[slug] {
            return cachedFile
        }

        let response = try await client.get(.init(string: url)).get()

        // If the response is within our 2xx "success"" range of status codes, cache and return the file.
        // If our status code is in the 4xx or 5xx "error" ranges, return the exact status code.
        // If our status code is in any other range (for example, 3xx redirect), return an internal server error.
        switch response.status.code {
        case 200 ..< 300:
            let contents = try response.content.decode(String.self)

            if self.shouldCache {
                self.cachedRemoteFiles[slug] = contents
            }

            return contents
        case 400 ..< 600:
            throw Abort(response.status)
        default:
            throw Abort(.internalServerError)
        }
    }

    public func clearRemoteCache() {
        self.cachedRemoteFiles = [:]
    }

    public func markdownPage<Page>(_ page: Page.Type, slug: String, bundle: Bundle, directory: String? = nil) throws -> Page where Page: MarkdownDocumentRendering {
        let markdown = try self.markdown(slug: slug, bundle: bundle, directory: directory)

        return .init(markdown: markdown)
    }

    public func markdownPage<Page>(_ page: Page.Type, slug: String, from url: String, using client: Client) async throws -> Page where Page: MarkdownDocumentRendering {
        let markdown = try await self.markdown(slug: slug, from: url, using: client)

        return .init(markdown: markdown)
    }

    public func htmlPage<Page>(_ page: Page.Type, slug: String, bundle: Bundle, directory: String? = nil) throws -> Page where Page: HTMLRendering {
        let html = try self.html(slug: slug, bundle: bundle, directory: directory)

        return .init(html: html)
    }

    public func htmlPage<Page>(_ page: Page.Type, slug: String, from url: String, using client: Client) async throws -> Page where Page: HTMLRendering {
        let html = try await self.html(slug: slug, from: url, using: client)

        return .init(html: html)
    }
}

// MARK: - Supporting Types

public protocol HTMLRendering: PlotVapor.Page {
    init(html: String)
}

public protocol MarkdownDocumentRendering: PlotVapor.Page {
    init(markdown: MarkdownDocument)
}

public enum FileExtension: String {
    case html
    case markdown = "md"
}

public enum ResourceError: Error {
    case fileNotFound(_ slug: String)
    case malformedSlug(_ slug: String)
}

extension ResourceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .fileNotFound(slug):
            return "File with slug '\(slug)' not found."
        case let .malformedSlug(slug):
            return "Malformed slug '\(slug)'."
        }
    }
}
