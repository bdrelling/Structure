// Copyright © 2022 Brian Drelling. All rights reserved.

import Ink
import Plot

struct MarkdownText: Component {
    private let html: String

    var body: Component {
        Text(self.html)
    }

    init(_ markdown: String) {
        self.html = MarkdownParser.custom.html(from: markdown)
    }
}