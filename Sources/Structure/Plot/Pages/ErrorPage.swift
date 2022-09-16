// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor
import Vapor

public struct ErrorPage: Page {
    public let message: ErrorMessage

    public var body: Component {
        StructurePage {
            self.message
        }
        .class("splash")
        .pageTitle(self.message.title)
    }

    public init(title: String, message: String) {
        self.message = .init(title: title, message: message)
    }

    public init?(_ status: HTTPResponseStatus) {
        guard let message = ErrorMessage(status) else {
            return nil
        }

        self.message = message
    }
}
