// Copyright © 2022 Brian Drelling. All rights reserved.

import KippleCore
import Vapor

public struct HostRedirectMiddleware: AsyncMiddleware {
    /// The host that other hosts should be directed to.
    public let primaryHost: String

    /// The post used for all hosts, if applicable.
    public let port: Int?

    /// An array of hosts that should redirect to the primary hosts.
    public let redirectedHosts: [String]

    /// The redirect HTTP status code to use when redirecting.
    public let redirectType: RedirectType

    /// The scheme to redirect to.
    public let scheme: URI.Scheme

    /// Initializes the middleware.
    /// - Parameters:
    ///   - primaryHost: The host that other hosts should be directed to.
    ///   - redirectedHosts: An array of hosts that should redirect to the primary host.
    ///   - port: The post used for all  hosts, if applicable. Defaults to `nil`.
    ///   - scheme: The scheme to redirect to. Defaults to `"https"`.
    ///   - redirectType: The redirect HTTP status code to use when redirecting.
    public init(primaryHost: String, redirectedHosts: [String], port: Int? = nil, scheme: URI.Scheme = .https, redirectType: RedirectType = .normal) {
        self.primaryHost = primaryHost
        self.redirectedHosts = redirectedHosts
        self.port = port
        self.scheme = scheme
        self.redirectType = redirectType
    }

    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // Get the host from the request header, replacing any port.
        // If this fails for some reason, simply pass the request to the next responder.
        guard let host = request.host?.replacing(pattern: ":[0-9]{1,5}") else {
            return try await next.respond(to: request)
        }

        // Only continue if the request host doesn't match the primary host.
        // Otherwise, pass the request to the next responder.
        guard host != self.primaryHost else {
            return try await next.respond(to: request)
        }

        // If this host is included in our list of hosts to redirect,
        // replace this host in the request with our primary host and resubmit the request.
        // Otherwise, return a HTTP 404 Not Found error.
        if self.redirectedHosts.contains(host) {
            // We need to rebuild our url again, because modifying the URI does not seem to work as intended.
            let url = URI(
                scheme: self.scheme,
                host: self.primaryHost,
                port: self.port,
                path: request.url.path,
                query: request.url.query,
                fragment: request.url.fragment
            )

            return request.redirect(to: url.string, type: self.redirectType)
        } else {
            throw Abort(.notFound)
        }
    }
}
