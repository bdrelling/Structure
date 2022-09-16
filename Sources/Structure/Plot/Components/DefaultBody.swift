// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor

public struct DefaultBody: Component {
    @EnvironmentValue(.scripts) var scripts

    private let content: ContentProvider

    @ComponentBuilder  public var body: Component {
        // Container
        Div {
            StructureNavbar()

            Div {
                self.content()
            }
            .class("content")

            SimpleFooter()
        }
        .class("container")

        // Scripts
        for script in self.scripts {
            Script(script)
        }
    }

    public init(@ComponentBuilder content: @escaping ContentProvider) {
        self.content = content
    }
}

// MARK: - Environment Keys

public extension EnvironmentKey where Value == [String] {
    static var scripts: Self {
        .init(defaultValue: [])
    }
}

// MARK: - Extensions

public extension Component {
    func scripts(_ scripts: [String]) -> Component {
        self.environmentValue(scripts, key: .scripts)
    }

    func script(script: String) -> Component {
        self.headScripts([script])
    }
}
