// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation

public extension String {
    func readingTime(wordsPerMinute: Float = 180, charactersPerWord: Float = 5) -> Int {
        let words = ceil(Float(self.count) / charactersPerWord)
        let minutes = ceil(words / wordsPerMinute)

        return Int(minutes)
    }
}
