// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot

public struct Icon: Component {
    private let `class`: String

    public var body: Component {
        Element(name: "i") {
            // Our component block needs something, so we give it empty text.
            Text("")
        }
        .class(self.class)
    }

    public init(class: String) {
        self.class = `class`
    }

    public init(name: String) {
        self.init(class: "icon icon-\(name)")
    }
}
