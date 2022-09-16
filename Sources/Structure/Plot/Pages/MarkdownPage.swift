// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor

public struct MarkdownPage: Page, MarkdownDocumentRendering {
    private let markdown: MarkdownDocument

    public var body: Component {
        HTMLEmbedPage(markdown: self.markdown)
    }

    public init(markdown: MarkdownDocument) {
        self.markdown = markdown
    }
}
