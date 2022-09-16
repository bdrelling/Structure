// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor

public struct StructureHead: Component {
    @ComponentBuilder  public var body: Component {
        DefaultHead()

        // Favicons
        Favicon("/icons/favicon-16x16.png", relationship: .icon, type: .png, size: .width(16))
        Favicon("/icons/favicon-32x32.png", relationship: .icon, type: .png, size: .width(32))
        Favicon("/icons/apple-touch-icon.png", relationship: .appleTouchIcon, type: .png, size: .width(180))
        HeadLink("/site.webmanifest", relationship: .manifest)
        HeadLink("/icons/safari-pinned-tab.svg", relationship: .maskIcon)
            .attribute(named: "color", value: "#1bd6cf")

        // No Script (for when JavaScript is disabled or unable to load)
        NoScript {
            Style(".js-only { display: none !important; }")
        }
    }

    public init() {}
}
