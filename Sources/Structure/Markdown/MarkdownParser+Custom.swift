import Ink

public extension MarkdownParser {
    static let custom: MarkdownParser = {
        // Add custom modifiers here.
        // For more info, see https://github.com/JohnSundell/Ink#powerful-customization

        var parser = MarkdownParser()

        let headingModifier = Modifier(target: .headings) { html, markdown in
            // Remove the tags to get the text.
            let text = html.replacingOccurrences(of: "</*h[0-9]>", with: "", options: [.regularExpression])
            // Convert the text into a slug.
            var slug = text.slugified()
            // Remove the leading number from the slug.
            slug = slug.replacingOccurrences(of: "^[0-9]+-", with: "", options: [.regularExpression])

            // Add the slug as the ID to the heading.
            let modifiedHTML = html.replacingOccurrences(of: "(<h[0-9])>", with: "$1 id=\"\(slug)\">", options: [.regularExpression])

            return modifiedHTML
        }

        parser.addModifier(headingModifier)

        return parser
    }()
}

// MARK: - Extensions

private extension String {
    func slugified() -> String {
        self.lowercased()
            // Replace spaces and underscores with hyphens.
            .replacingOccurrences(of: #"[\s_]"#, with: "-", options: [.regularExpression])
            // Remove illegal characters.
            .replacingOccurrences(of: #"[:;?#@!$&'"()*+=,\[\]\.]*"#, with: "", options: [.regularExpression])
    }
}
