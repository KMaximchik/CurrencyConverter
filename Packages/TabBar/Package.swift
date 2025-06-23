// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "TabBar",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "TabBar",
            targets: ["TabBar"]
        ),
    ],
    dependencies: [
        .package(path: "../Exchange"),
        .package(path: "../History"),
        .package(path: "../DesignSystem"),
        .package(path: "../Core"),
        .package(path: "../UseCases"),
        .package(path: "../Extensions")
    ],
    targets: [
        .target(
            name: "TabBar",
            dependencies: [
                .byName(name: "Exchange"),
                .byName(name: "History"),
                .byName(name: "DesignSystem"),
                .byName(name: "Core"),
                .byName(name: "UseCases"),
                .byName(name: "Extensions")
            ],
            path: "Sources"
        ),
    ]
)
