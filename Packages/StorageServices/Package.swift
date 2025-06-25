// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "StorageServices",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "StorageServices",
            targets: ["StorageServices"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Utilities")
    ],
    targets: [
        .target(
            name: "StorageServices",
            dependencies: [
                .byName(name: "Core"),
                .byName(name: "Utilities")
            ],
            path: "Sources"
        ),
    ]
)
