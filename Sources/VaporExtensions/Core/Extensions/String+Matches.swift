// Copyright © 2022 Brian Drelling. All rights reserved.

import Foundation

extension String {
    func captureGroups(for pattern: String, range: NSRange? = nil) -> [String] {
        let range = range ?? NSRange(self.startIndex..., in: self)

        guard let matches = try? NSRegularExpression(pattern: pattern)
            .matches(in: self, range: range) else {
            return []
        }

        return matches
            .flatMap { match in
                [Int](0 ..< match.numberOfRanges)
                    .map { match.range(at: $0) }
            }
            .compactMap { matchRange in
                // Ignore matching the entire string
                guard matchRange != range else {
                    return nil
                }

                // Extract the substring matching the capture group
                if let substringRange = Range(matchRange, in: self) {
                    return String(self[substringRange])
                } else {
                    return nil
                }
            }
    }

    func firstCaptureGroup(for pattern: String, range: NSRange? = nil) -> String? {
        self.captureGroups(for: pattern, range: range).first
    }
}
