// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation
import Plot
import PlotVapor

public struct HTMLEmbedPage: Page, HTMLRendering {
    private let html: String

    #warning("Can this be raw HTML instead of wrapped in a Div?")
    public var body: Component {
        StructurePage {
            Div(html: self.html)
        }
    }

    public init(html: String) {
        self.html = html
    }
}

// MARK: - Extensions

extension HTMLEmbedPage: MarkdownDocumentRendering {
    public init(markdown: MarkdownDocument) {
        self.init(html: markdown.html)
    }
}
