// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

public protocol CommandDefining {
    var registeredCommand: AnyCommand { get }
    var preferredVerb: String { get }
}

public struct CommandDefinition: CommandDefining {
    public var registeredCommand: AnyCommand
    public var preferredVerb: String
}

public extension AnyCommand where Self: CommandDefining {
    var registeredCommand: AnyCommand {
        self
    }
}

public extension Commands {
    mutating func register(_ commands: [CommandDefining]) {
        for command in commands {
            self.use(command.registeredCommand, as: command.preferredVerb)
        }
    }
}
