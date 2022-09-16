// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation
import Ink

public struct MarkdownDocument: Equatable {
    // MARK: Properties

    /// The title of the document.
    public let title: String

    /// The slug of the document.
    /// This value is both the filename and URL slug.
    public let slug: String

    /// A dictionary of metadata from the markdown file.
    public let metadata: Metadata

    /// The full HTML of the article.
    /// This is parsed from the raw markdown text.
    public let html: String

    /// The raw markdown text of the article.
    /// This is used mostly for debugging purposes.
    public let markdownText: String

    /// The estimated number of minutes it will take to read this article.
    public let readingTime: Int

    public var readingTimeFormatted: String {
        "\(self.readingTime) min read"
    }

    private init(
        title: String,
        slug: String,
        metadata: Metadata,
        html: String,
        markdownText: String,
        readingTime: Int
    ) {
        self.title = title
        self.slug = slug
        self.metadata = metadata
        self.html = html
        self.markdownText = markdownText
        self.readingTime = readingTime
    }

    private init(slug: String, markdown: Ink.Markdown, text: String) {
        self.init(
            title: markdown.metadata["title"] ?? markdown.title ?? slug,
            slug: slug,
            metadata: markdown.metadata,
            html: markdown.html,
            markdownText: text,
            readingTime: text.readingTime()
        )
    }

    public init(slug: String, text: String) {
        let markdown = MarkdownParser.custom.parse(text)
        self.init(slug: slug, markdown: markdown, text: text)
    }
}

// MARK: - Supporting Types

public extension MarkdownDocument {
    typealias Metadata = [String: String]
}

// MARK: - Extensions

public extension MarkdownDocument.Metadata {
    func bool(forKey key: String) -> Bool? {
        if let rawValue = self[key] {
            return rawValue == "true"
        } else {
            return nil
        }
    }

    func string(forKey key: String) -> String? {
        self[key]
    }

    func date(forKey key: String, formatter: DateFormatter = .init()) -> Date? {
        guard let rawDate = self[key] else {
            return nil
        }

        return formatter.date(from: rawDate)
    }
}
