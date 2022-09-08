// Copyright © 2022 Brian Drelling. All rights reserved.

Copyright © 2022 Brian Drelling.All rights reserved.

    import KippleCore
import Vapor
import VaporExtensions

public struct SubdomainRedirectMiddleware: AsyncMiddleware {
    /// The subdomain that other subdomains should be directed to.
    /// Defaults to `""`, which represents _no_ subdomain.
    /// (eg. "briandrelling.com" would use `""`, but "www.briandrelling.com" would use `"www"`.
    public let primarySubdomain: String

    /// An array of subdomains that should redirect to the primary subdomain,
    /// rather than throwing an HTTP 404 (Not Found) error.
    public let redirectedSubdomains: [String]

    /// Initializes the middleware.
    /// - Parameters:
    ///   - primarySubdomain: The subdomain that other subdomains should be directed to. Defaults to `""`, which represents _no_ subdomain.
    ///   - redirectedSubdomains: An array of subdomains that should redirect to the primary subdomain.
    public init(primarySubdomain: String = "", redirectedSubdomains: [String] = ["www"]) {
        self.primarySubdomain = primarySubdomain
        self.redirectedSubdomains = redirectedSubdomains
    }

    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // Get the subdomain from the request.
        // If the subdomain is "nil", it is evaluated as an empty string, which represents the apex domain.
        let subdomain = request.subdomain ?? ""

        // If the request's subdomain matches the primary subdomain, continue.
        guard subdomain != self.primarySubdomain else {
            return try await next.respond(to: request)
        }

        // If this subdomain is included in our list of subdomains to redirect,
        // replace this subdomain in the request with our primary domain and resubmit the request.
        if self.redirectedSubdomains.contains(subdomain) {
            guard var host = request.host?.replacingOccurrences(of: "\(subdomain).", with: "\(self.primarySubdomain).") else {
                throw Abort(.badRequest)
            }

            // If our host was replaced with an empty subdomain (matching the apex domain), remove the leading '.'.
            host = String(host.dropFirst())

            let redirectURL = "https://\(host)\(request.url)"

            return request.redirect(to: redirectURL)
        } else {
            throw Abort(.notFound)
        }
    }
}
