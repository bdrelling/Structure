// Copyright © 2022 Brian Drelling. All rights reserved.

import Plot
import PlotVapor

public struct SplashTemplate: Template {
    public static func body(with page: Page) -> Component {
        Div(
            page.body
        )
        .style("""
        display: flex;
        align-items: center;
        flex-direction: column;
        min-height: 100%;
        justify-content: center;
        text-align: center;
        """)
    }
}
