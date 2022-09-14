import Ink
import Plot

struct Markdown: Component {
    private let html: String

    var body: Component {
        Text(self.html)
    }

    init(_ markdown: String) {
        self.html = MarkdownParser.custom.html(from: markdown)
    }
}
