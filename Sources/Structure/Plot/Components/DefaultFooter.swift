// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot

public struct DefaultFooter: Component {
    private static let vaporURL = "https://vapor.codes"

    public var body: Component {
        Plot.Footer {
            Div {
                Span("Made with ")
                Link("Vapor", url: Self.vaporURL)
            }
            .class("made-with-vapor")
        }
    }

    public init() {}
}
