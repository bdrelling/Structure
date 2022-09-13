// Copyright © 2022 Brian Drelling. All rights reserved.

public struct Breadcrumb {
    public let text: String
    public let url: String?

    public init(text: String, url: String? = nil) {
        self.text = text
        self.url = url
    }

    public func withoutURL() -> Self {
        .init(text: self.text)
    }
}

public extension Breadcrumb {
    static let apps = Breadcrumb(text: "Apps", url: "/apps")
    static let blog = Breadcrumb(text: "Blog", url: "/blog")
    static let home = Breadcrumb(text: "Home", url: "/")
    static let projects = Breadcrumb(text: "Projects", url: "/projects")
}
