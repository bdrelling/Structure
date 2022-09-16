// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor

public struct StructurePage: Page {
    @ComponentBuilder private let content: Component.ContentProvider

    @EnvironmentValue(.request) var request
    @EnvironmentValue(.styleSheets) var styleSheets
    @EnvironmentValue(.headScripts) var headScripts

    private let route: PageRoute?

    private let defaultStyleSheets = [
        "/cdn/css/structure/structure.css",
    ]

    private let defaultHeadScripts = [
        "/cdn/js/structure/detect_theme.js",
    ]

    public var body: Component {
        ComponentGroup {
            StructureHead()
                .styleSheets(self.defaultStyleSheets + self.styleSheets)
                .headScripts(self.defaultHeadScripts + self.headScripts)

            DefaultBody {
                self.content()
            }
        }
        .route(self.route)
        .canonicalURL(self.request?.canonicalURL)
    }

    public init(route: PageRoute? = nil, @ComponentBuilder content: @escaping Component.ContentProvider) {
        self.route = route
        self.content = content
    }
}
