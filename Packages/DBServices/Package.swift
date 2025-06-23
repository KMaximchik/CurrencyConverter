// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DBServices",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "DBServices",
            targets: ["DBServices"]
        ),
    ],
    dependencies: [
        .package(path: "../Network"),
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "DBServices",
            dependencies: [
                .byName(name: "Network"),
                .byName(name: "Core")
            ],
            path: "Sources"
        ),
    ]
)
