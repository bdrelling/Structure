import Vapor
import VaporSitemap

public extension Application {
    private func configureSitemap(baseURL: String, paths: [String]) throws {
        // creates a dynamic sitemap
        self.middleware.use(SitemapMiddleware(
            isSitemap: { req in
                // Whether or not the middleware should handle the path.
                req.url.path == "/sitemap.xml"
            }, generateURLs: { req in
                paths.map { path in
                    .init(stringLiteral: "\(baseURL)/\(path)")
                }
            }
        ))
    }
}
