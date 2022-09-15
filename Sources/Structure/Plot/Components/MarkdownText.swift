// Copyright © 2022 Brian Drelling. All rights reserved.

import Ink
import Plot

public struct MarkdownText: Component {
    private let html: String

    public var body: Component {
        Text(self.html)
    }

    public init(_ markdown: String) {
        self.html = MarkdownParser.custom.html(from: markdown)
    }
}
