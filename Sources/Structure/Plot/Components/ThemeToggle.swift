// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot

public struct ThemeToggle: Component {
    public var body: Component {
        Button {
            Icon(class: "bi bi-moon-stars-fill light-mode-only")
            Icon(class: "bi bi-sun-fill dark-mode-only")
        }
        .attribute(named: "onclick", value: "toggleTheme()")
        .class("toggle-theme js-only")
    }

    public init() {}
}
