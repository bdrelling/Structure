// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import Vapor

public struct ErrorMessage: Component {
    public let title: String
    public let message: String

    public var body: Component {
        Div {
            H1(self.title)
            Paragraph(self.message)
            Link("Take me back home!", url: "/")
        }
    }

    /// Initializes an `ErrorPage` with a given title and message.
    /// - Parameters:
    ///   - title: The title to display, both for the URL bar and the view.
    ///   - message: The message to display in the view.
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }

    /// Initializes an `ErrorPage` using defaults based off of an `HTTPResponseStatus`.
    /// If the `HTTPResponseStatus` does not have valid defaults, the initializer will return `nil`.
    /// - Parameter status: The `HTTPResponseStatus` to fetch defaults for.
    public init?(_ status: HTTPResponseStatus) {
        switch status {
        case .notFound:
            self.init(
                title: "Page Not Found",
                message: "The page you're looking for doesn't seem to exist. Whoops!"
            )
        default:
            return nil
        }
    }
}
