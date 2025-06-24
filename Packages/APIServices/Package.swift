// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "APIServices",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "APIServices",
            targets: ["APIServices"]
        ),
    ],
    dependencies: [
        .package(path: "../Network"),
        .package(path: "../DTOs"),
        .package(path: "../Domain"),
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "APIServices",
            dependencies: [
                .byName(name: "Network"),
                .byName(name: "DTOs"),
                .byName(name: "Domain"),
                .byName(name: "Core")
            ],
            path: "Sources"
        ),
    ]
)
