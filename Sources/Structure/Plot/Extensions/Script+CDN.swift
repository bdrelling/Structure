// Copyright © 2022 Brian Drelling. All rights reserved.

import PlotVapor

public extension Script {
    /// Initializes a `<script>` element pointed to the Structure CDN.
    init(tag: String = "latest", cdnPath path: String) {
        let path = path.trimmingSlashes()
        self.init("/cdn/js/\(path)")
    }
}
