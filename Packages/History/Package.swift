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
        .package(path: "../Utilities"),
        .package(path: "../Core"),
        .package(path: "../UseCases"),
        .package(url: "https://github.com/johnpatrickmorgan/FlowStacks", from: "0.8.4")
    ],
    targets: [
        .target(
            name: "History",
            dependencies: [
                .byName(name: "DesignSystem"),
                .byName(name: "Utilities"),
                .byName(name: "Core"),
                .byName(name: "UseCases"),
                .product(name: "FlowStacks", package: "FlowStacks")
            ],
            path: "Sources"
        ),
    ]
)
