// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor

public struct DefaultHeadContent: Component {
    public let siteTitle: String
    public let pageTitle: String?
    public let canonicalURL: String?

    public var body: Component {
        ComponentGroup {
            // Charset
            Meta(charset: .utf8)
            // Responsiveness
            Meta(name: "viewport", content: "width=device-width, initial-scale=1")
            // Title
            if let pageTitle = self.pageTitle {
                Title("\(pageTitle) - \(self.siteTitle)")
            } else {
                Title(self.siteTitle)
            }
            // Canonical URL
            if let canonicalURL = self.canonicalURL {
                HeadLink(canonicalURL, relationship: .canonical)
            }
            // Theme Color
            Meta(themeColor: Theme.dark.backgroundColor)
            // Icons
            Favicon("/images/favicon.png")
            HeadLink("/images/favicon.png", relationship: .icon, type: .png, sizes: "16x16")
            HeadLink("/images/favicon_32.png", relationship: .icon, type: .png, sizes: "32x32")
            HeadLink("/images/favicon_180.png", relationship: .appleTouchIcon, sizes: "180x180")
            // Stylesheets
            StyleSheet("/styles/prism-xcode-dark.css")
            StyleSheet("/styles/structure.css")
            StyleSheet("/styles/primary.css")
            StyleSheet("/styles/components.css")
            StyleSheet("/styles/icons.css")
            // Scripts
            Script("/scripts/detect_theme.js")
            // No Script -- For when JavaScript is disabled or unable to load.
            NoScript {
                StyleSheet("/styles/noscript.css")
            }
        }
    }

    public init(siteTitle: String, pageTitle: String? = nil, canonicalURL: String? = nil) {
        self.siteTitle = siteTitle
        self.pageTitle = pageTitle
        self.canonicalURL = canonicalURL
    }

    init(siteTitle: String, page: Page) {
        guard let page = page as? HeadConfiguring else {
            self.init(siteTitle: siteTitle)
            return
        }

        self.init(
            siteTitle: siteTitle,
            pageTitle: page.title,
            canonicalURL: page.canonicalURL
        )
    }
}
