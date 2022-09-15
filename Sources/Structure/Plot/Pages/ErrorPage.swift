// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor
import Vapor

public struct ErrorPage: DefaultPage {
    public typealias Template = SplashTemplate

    public let title: String
    public let siteTitle: String? = nil
    public let themeColors: [ThemeColor] = []
    public let breadcrumbs: [Breadcrumb] = []
    public let canonicalURL: String? = nil

    public let message: ErrorMessage

    public var head: Component {
        DefaultHeadContent(page: self)
    }

    public var body: Component {
        self.message
    }

    public init(title: String, message: String) {
        self.message = .init(title: title, message: message)
        self.title = title
    }

    public init?(_ status: HTTPResponseStatus) {
        guard let message = ErrorMessage(status) else {
            return nil
        }

        self.message = message
        self.title = message.title
    }
}
