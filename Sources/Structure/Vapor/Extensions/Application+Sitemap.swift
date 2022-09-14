// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import Vapor
import VaporSitemap

public extension Application {
    func configureSitemap(path: String = "/sitemap.xml", sitemap: Sitemap) {
        // creates a dynamic sitemap
        self.middleware.use(SitemapMiddleware(
            path: path,
            sitemap: sitemap
        ))
    }

    func configureSitemap(path: String = "/sitemap.xml", baseURL: String, paths: [String]) {
        let sitemap = Sitemap(
            .forEach(paths) { path in
                .url(.loc("\(baseURL)/\(path)"))
            }
        )
        self.configureSitemap(path: path, sitemap: sitemap)
    }
}
