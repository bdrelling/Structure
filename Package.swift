// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "VaporExtensions",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .library(name: "VaporExtensions", targets: ["VaporExtensions"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-kipple/Core", from: "0.10.2"),
        .package(url: "https://github.com/vapor/vapor", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent", from: "4.4.0"),
        // Development
        .package(url: "https://github.com/swift-kipple/Tools", from: "0.3.1"),
    ],
    targets: [
        .target(
            name: "VaporExtensions",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "KippleCore", package: "Core"),
                .product(name: "Vapor", package: "vapor"),
            ]
        )
    ]
)