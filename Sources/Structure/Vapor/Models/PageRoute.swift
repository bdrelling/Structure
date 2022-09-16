// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import Vapor

public struct PageRoute {
    public let title: String
    public let pathComponents: [PathComponent]
    public let url: String
    public let breadcrumbs: [PageRoute]

    public var path: String {
        self.pathComponents.string
    }

    public init(_ path: [PathComponent], title: String, url: String, breadcrumbs: [PageRoute]) {
        self.pathComponents = path
        self.title = title
        self.url = url
        self.breadcrumbs = breadcrumbs
    }

    public init(_ pathComponents: PathComponent..., title: String, url: String, breadcrumbs: [PageRoute]) {
        self.init(pathComponents, title: title, url: url, breadcrumbs: breadcrumbs)
    }
}

// MARK: - Environment Keys

public extension EnvironmentKey where Value == PageRoute? {
    static var pageRoute: Self {
        .init(defaultValue: nil)
    }
}

// MARK: - Extensions

public extension Component {
    func route(_ route: PageRoute?) -> Component {
        let component = self.environmentValue(route, key: .pageRoute)

        guard let route = route else {
            return component
        }

        return component
            .pageTitle(route.title)
            .canonicalURL(route.url)
            .breadcrumbs(route.breadcrumbs)
    }
}
