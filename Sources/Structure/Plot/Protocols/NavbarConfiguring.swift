// Copyright © 2022 Brian Drelling. All rights reserved.

import PlotVapor

public protocol NavbarConfiguring: Page {
    var breadcrumbs: [Breadcrumb] { get }
}

public extension NavbarConfiguring {
    var breadcrumbs: [Breadcrumb] {
        [.home]
    }
}
