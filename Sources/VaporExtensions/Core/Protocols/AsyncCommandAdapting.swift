// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public protocol AsyncCommandAdapting: Command {
    func run(using context: CommandContext, signature: Signature) async throws
}

public extension Command where Self: AsyncCommandAdapting {
    func run(using context: CommandContext, signature: Signature) throws {
        // Until AsyncCommand is properly impleented in Vapor, we'll just abstract away the function for safe synchronous handling.
        // Source for this workaround: https://github.com/vapor/console-kit/issues/171

        let promise = context.application.eventLoopGroup.next().makePromise(of: Void.self)

        promise.completeWithTask {
            try await self.run(using: context, signature: signature)
        }

        try promise.futureResult.wait()
    }
}
