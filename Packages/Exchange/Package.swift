// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Exchange",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Exchange",
            targets: ["Exchange"]
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
            name: "Exchange",
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
