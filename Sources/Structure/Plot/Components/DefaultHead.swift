// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor

public struct DefaultHead: Component {
    @EnvironmentValue(.pageTitle) var pageTitle
    @EnvironmentValue(.siteTitle) var siteTitle
    @EnvironmentValue(.canonicalURL) var canonicalURL
    @EnvironmentValue(.themeColors) var themeColors
    @EnvironmentValue(.headScripts) var headScripts
    @EnvironmentValue(.styleSheets) var styleSheets
    @EnvironmentValue(.icons) var icons

    private var title: String? {
        if let pageTitle = self.pageTitle, let siteTitle = self.siteTitle {
            return "\(pageTitle) - \(siteTitle)"
        } else if let pageTitle = self.pageTitle {
            return pageTitle
        } else if let siteTitle = self.siteTitle {
            return siteTitle
        } else {
            return nil
        }
    }

    @ComponentBuilder  public var body: Component {
        // Metaw
        Meta(charset: .utf8)
        Meta(name: "viewport", content: "width=device-width, initial-scale=1")

        for themeColor in self.themeColors {
            ThemeColor(themeColor)
        }

        // Title
        if let title = self.title {
            Title(title)
        }

        // Canonical URL
        if let canonicalURL = self.canonicalURL {
            HeadLink(canonicalURL, relationship: .canonical)
        }

        // StyleSheets
        for styleSheet in self.styleSheets {
            StyleSheet(styleSheet)
        }

        // Scripts
        for script in self.headScripts {
            Script(script)
        }
    }

    public init() {}
}

// MARK: - Environment Keys

public extension EnvironmentKey where Value == String? {
    static var pageTitle: Self {
        .init(defaultValue: nil)
    }

    static var siteTitle: Self {
        .init(defaultValue: nil)
    }
}

public extension EnvironmentKey where Value == String? {
    static var canonicalURL: Self {
        .init(defaultValue: nil)
    }
}

public extension EnvironmentKey where Value == [String] {
    static var headScripts: Self {
        .init(defaultValue: [])
    }

    static var styleSheets: Self {
        .init(defaultValue: [])
    }
}

public extension EnvironmentKey where Value == [ThemeColor.Value] {
    static var themeColors: Self {
        .init(defaultValue: [])
    }
}

public extension EnvironmentKey where Value == [String] {
    static var icons: Self {
        .init(defaultValue: [])
    }
}

// MARK: - Extensions

public extension Component {
    func pageTitle(_ title: String) -> Component {
        self.environmentValue(title, key: .pageTitle)
    }

    func siteTitle(_ title: String) -> Component {
        self.environmentValue(title, key: .siteTitle)
    }

    func canonicalURL(_ url: String?) -> Component {
        self.environmentValue(url, key: .canonicalURL)
    }

    func headScripts(_ scripts: [String]) -> Component {
        self.environmentValue(scripts, key: .headScripts)
    }

    func headScript(script: String) -> Component {
        self.headScripts([script])
    }

    func styleSheets(_ styleSheets: [String]) -> Component {
        self.environmentValue(styleSheets, key: .styleSheets)
    }

    func styleSheet(styleSheet: String) -> Component {
        self.headScripts([styleSheet])
    }

    func themeColors(_ colors: [ThemeColor.Value]) -> Component {
        self.environmentValue(colors, key: .themeColors)
    }

    func themeColor(_ color: ThemeColor.Value) -> Component {
        self.themeColors([color])
    }

    func themeColor(_ color: String) -> Component {
        self.themeColor(ThemeColor.Value(color))
    }

    func icons(_ icons: [String]) -> Component {
        self.environmentValue(icons, key: .icons)
    }

    func favicon(_ favicon: String) -> Component {
        self.icons([favicon])
    }
}
