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
        // 💧 Vapor
        .package(url: "https://github.com/vapor/vapor", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent", from: "4.4.0"),
        // Development
        .package(url: "https://github.com/swift-kipple/Tools", from: "0.2.5"),
    ],
    targets: [
        .target(
            name: "VaporExtensions",
            dependencies: [
                // Vapor
                .product(name: "Fluent", package: "fluent"),
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
    ]
)