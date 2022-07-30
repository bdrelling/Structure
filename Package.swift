// swift-tools-version:5.6

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
        .package(url: "https://github.com/vapor/vapor", .upToNextMajor(from: "4.63.0")),
        .package(url: "https://github.com/vapor/fluent", .upToNextMajor(from: "4.4.0")),
        // Development
        .package(url: "https://github.com/swift-kipple/Tools", from: "0.2.1"),
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
