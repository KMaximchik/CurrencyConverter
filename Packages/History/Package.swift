// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "History",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "History",
            targets: ["History"]
        ),
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../Extensions"),
        .package(path: "../Core"),
        .package(path: "../UseCases")
    ],
    targets: [
        .target(
            name: "History",
            dependencies: [
                .byName(name: "DesignSystem"),
                .byName(name: "Extensions"),
                .byName(name: "Core"),
                .byName(name: "UseCases")
            ],
            path: "Sources"
        ),
    ]
)
