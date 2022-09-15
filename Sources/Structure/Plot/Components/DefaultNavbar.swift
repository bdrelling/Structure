// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor
import Vapor

public struct DefaultNavbar: Component {
    public let breadcrumbs: [Breadcrumb]

    public var body: Component {
        ComponentGroup {
            Navigation {
                Div {
                    for breadcrumb in self.breadcrumbs {
                        if let url = breadcrumb.url {
                            Link(url: url) {
                                Text(breadcrumb.text)
                            }
                        } else {
                            Span(breadcrumb.text)
                        }

                        Span("/")
                            .class("divider")
                    }
                }
                .class("horizontal-menu")

                ThemeToggle()
            }
            .class("navbar")

            ConstructionSign()
        }
    }

    public init(breadcrumbs: [Breadcrumb] = []) {
        self.breadcrumbs = breadcrumbs
    }

    public init(breadcrumbs: [(text: String, url: String?)]) {
        self.init(breadcrumbs: breadcrumbs.map(Breadcrumb.init))
    }

    public init(page: Page) {
        guard let page = page as? NavbarConfiguring else {
            self.init()
            return
        }

        self.init(breadcrumbs: page.breadcrumbs)
    }
}

// MARK: - Supporting Types

public struct Breadcrumb {
    public let text: String
    public let url: String?

    public init(text: String, url: String? = nil) {
        self.text = text
        self.url = url
    }

    public func withoutURL() -> Self {
        .init(text: self.text)
    }
}

public protocol NavbarConfiguring: Page {
    var breadcrumbs: [Breadcrumb] { get }
}
