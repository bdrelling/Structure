// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation
import Plot

public struct ConstructionSign: Component {
    public static let defaultMessage = """
    Thanks for stopping by!
    This website is currently undergoing some much-needed maintenance,
    so parts of the site may appear broken for the time being.
    """

    private var isUnderConstruction: Bool = {
        ProcessInfo.processInfo.environment["UNDER_CONSTRUCTION"] == "true"
    }()

    @ComponentBuilder var content: ContentProvider

    public var body: Component {
        ComponentGroup {
            if self.isUnderConstruction {
                Div(content: self.content)
                    .class("construction-sign")
            }
        }
    }

    public init(@ComponentBuilder content: @escaping ContentProvider) {
        self.content = content
    }

    public init(_ component: Component) {
        self.init { component }
    }

    public init(_ message: String = Self.defaultMessage) {
        self.init(Text(message))
    }
}
