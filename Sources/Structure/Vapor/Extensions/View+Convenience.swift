// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public extension View {
    init(data: Data) {
        let buffer = ByteBuffer(data: data)
        self.init(data: buffer)
    }

    init(string: String) {
        let buffer = ByteBuffer(string: string)
        self.init(data: buffer)
    }
}
