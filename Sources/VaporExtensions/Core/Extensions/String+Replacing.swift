// Copyright © 2022 Brian Drelling. All rights reserved.

extension String {
    func replacing(pattern: String, with replacement: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .anchorsMatchLines])
            let range = NSRange(self.startIndex..., in: self)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replacement)
        } catch {
            return self
        }
    }
}
