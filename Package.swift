// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Structure",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .library(name: "Structure", targets: ["Structure"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bdrelling/PlotVapor", from: "0.5.0"),
        .package(url: "https://github.com/JohnSundell/Ink", from: "0.5.1"),
        .package(url: "https://github.com/swift-kipple/Core", from: "0.11.0"),
        .package(url: "https://github.com/vapor/vapor", from: "4.74.0"),
        .package(url: "https://github.com/vapor/fluent", from: "4.7.0"),
        // Development
        .package(url: "https://github.com/swift-kipple/Tools", from: "0.3.7"),
    ],
    targets: [
        .target(
            name: "Structure",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "Ink", package: "Ink"),
                .product(name: "KippleCore", package: "Core"),
                .product(name: "PlotVapor", package: "PlotVapor"),
                .product(name: "Vapor", package: "vapor"),
            ],
            resources: [
                .copy("Resources/css"),
                .copy("Resources/js"),
            ]
        ),
        .testTarget(
            name: "StructureTests",
            dependencies: [
                .target(name: "Structure"),
            ]
        ),
    ]
)

