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
        .package(path: "../Utilities"),
        .package(path: "../Core"),
        .package(path: "../UseCases"),
        .package(path: "../Domain"),
        .package(url: "https://github.com/johnpatrickmorgan/FlowStacks", from: "0.8.4")
    ],
    targets: [
        .target(
            name: "Exchange",
            dependencies: [
                .byName(name: "DesignSystem"),
                .byName(name: "Utilities"),
                .byName(name: "Core"),
                .byName(name: "UseCases"),
                .byName(name: "Domain"),
                .product(name: "FlowStacks", package: "FlowStacks")
            ],
            path: "Sources"
        ),
    ]
)
