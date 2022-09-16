// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor
import Vapor

public struct StructureNavbar: Component {
    @EnvironmentValue(.pageRoute) var pageRoute
    @EnvironmentValue(.breadcrumbs) var breadcrumbs
    @EnvironmentValue(.isUnderConstruction) var isUnderConstruction
    @EnvironmentValue(.shouldHideRouteBreadcrumb) var shouldHideRouteBreadcrumb

    public var body: Component {
        ComponentGroup {
            Navigation {
                if !self.breadcrumbs.isEmpty {
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

                        if !self.shouldHideRouteBreadcrumb, let pageRoute = self.pageRoute {
                            Span(pageRoute.title)

                            Span("/")
                                .class("divider")
                        }
                    }
                    .class("horizontal-menu")
                }

                ThemeToggle()
            }
            .class("navbar")

            if self.isUnderConstruction {
                ConstructionSign()
            }
        }
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

// MARK: - Environment Keys

public extension EnvironmentKey where Value == [Breadcrumb] {
    static var breadcrumbs: Self {
        .init(defaultValue: [])
    }
}

public extension EnvironmentKey where Value == Bool {
    static var shouldHideRouteBreadcrumb: Self {
        .init(defaultValue: false)
    }
}

public extension EnvironmentKey where Value == Bool {
    static var isUnderConstruction: Self {
        .init(defaultValue: false)
    }
}

// MARK: - Extensions

public extension Component {
    func breadcrumbs(_ breadcrumbs: [Breadcrumb]) -> Component {
        self.environmentValue(breadcrumbs, key: .breadcrumbs)
    }

    func breadcrumbs(_ breadcrumbs: [(text: String, url: String?)]) -> Component {
        self.breadcrumbs(breadcrumbs.map(Breadcrumb.init))
    }

    func breadcrumbs(_ routes: [PageRoute]) -> Component {
        self.breadcrumbs(routes.map { Breadcrumb(text: $0.title, url: $0.url) })
    }

    func breadcrumbs(for route: PageRoute) -> Component {
        self.breadcrumbs(route.breadcrumbs)
    }

    func hideRouteBreadcrumb(_ hideRouteBreadcrumb: Bool = true) -> Component {
        self.environmentValue(hideRouteBreadcrumb, key: .shouldHideRouteBreadcrumb)
    }

    func isUnderConstruction(_ isUnderConstruction: Bool = true) -> Component {
        self.environmentValue(isUnderConstruction, key: .isUnderConstruction)
    }
}
