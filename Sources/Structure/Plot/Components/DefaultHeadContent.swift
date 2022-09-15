// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor

public struct DefaultHeadContent: Component {
    public let title: String?
    public let canonicalURL: String?
    public let themeColors: [ThemeColor]
    public let primaryStyleSheet: String?
    public let shouldDetectTheme: Bool
    public let shouldIncludeFavicons: Bool

    public var body: Component {
        ComponentGroup {
            // Charset
            Meta(charset: .utf8)

            // Viewport (for responsiveness)
            Meta(name: "viewport", content: "width=device-width, initial-scale=1")

            // Icons
            if self.shouldIncludeFavicons {
                Favicon("/images/favicon.png")
                HeadLink("/images/favicon.png", relationship: .icon, type: .png, sizes: "16x16")
                HeadLink("/images/favicon_32.png", relationship: .icon, type: .png, sizes: "32x32")
                HeadLink("/images/favicon_180.png", relationship: .appleTouchIcon, sizes: "180x180")
            }

            // StyleSheets
            StyleSheet(cdnPath: "structure/structure.css")

            if let primaryStyleSheet = self.primaryStyleSheet {
                StyleSheet(primaryStyleSheet)
            }

            // Scripts
            if self.shouldDetectTheme {
                Script(cdnPath: "structure/detect_theme.js")
            }

            // No Script (for when JavaScript is disabled or unable to load)
            NoScript {
                Style(".js-only { display: none !important; }")
            }

            // Title
            if let title = self.title {
                Title(title)
            }

            // Canonical URL
            if let canonicalURL = self.canonicalURL {
                HeadLink(canonicalURL, relationship: .canonical)
            }

            // Theme Colors
            if !self.themeColors.isEmpty {
                for themeColor in self.themeColors {
                    Meta(themeColor: themeColor.color, colorScheme: themeColor.colorScheme)
                }
            } else if self.shouldDetectTheme {
                // If no theme color was provided, leave a placeholder element for our detect_theme.js script, assuming theme detection is enabled.
                // TODO: Make the detect_theme.js script handle this by itself!
                Meta(name: "theme-color")
            }
        }
    }

    public init(
        title: String? = nil,
        canonicalURL: String? = nil,
        themeColors: [ThemeColor] = [],
        primaryStyleSheet: String? = "/styles/main.css",
        shouldDetectTheme: Bool = true,
        shouldIncludeFavicons: Bool = true
    ) {
        self.title = title
        self.canonicalURL = canonicalURL
        self.themeColors = themeColors
        self.primaryStyleSheet = primaryStyleSheet
        self.shouldDetectTheme = shouldDetectTheme
        self.shouldIncludeFavicons = shouldIncludeFavicons
    }
}

// MARK: - Supporting Types

public protocol HeadConfiguring: Page {
    var title: String { get }
    var canonicalURL: String? { get }
    var siteTitle: String? { get }
    var themeColors: [ThemeColor] { get }
    var primaryStyleSheet: String? { get }
    var shouldDetectTheme: Bool { get }
    var shouldIncludeFavicons: Bool { get }
}

public typealias ThemeColor = (color: String, colorScheme: String?)

// MARK: - Extensions

public extension DefaultHeadContent {
    init(page: Page) {
        guard let page = page as? HeadConfiguring else {
            self.init()
            return
        }

        self.init(
            title: page.fullTitle,
            canonicalURL: page.canonicalURL,
            themeColors: page.themeColors,
            primaryStyleSheet: page.primaryStyleSheet,
            shouldDetectTheme: page.shouldDetectTheme,
            shouldIncludeFavicons: page.shouldIncludeFavicons
        )
    }
}

public extension HeadConfiguring {
    var primaryStyleSheet: String? {
        "/styles/main.css"
    }

    var shouldDetectTheme: Bool {
        true
    }

    var shouldIncludeFavicons: Bool {
        true
    }

    var fullTitle: String {
        if let siteTitle = self.siteTitle {
            return "\(self.title) - \(siteTitle)"
        } else {
            return self.title
        }
    }
}
