// Copyright © 2022 Brian Drelling. All rights reserved.

import PlotVapor

public extension Script {
    init(cdnURL: String = "https://cdn.jsdelivr.net/gh/bdrelling/Structure/cdn/js", cdnPath path: String) {
        let path = path.trimmingSlashes()
        self.init("\(cdnURL)/\(path)")
    }
}
