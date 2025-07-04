// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Models",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Models",
            targets: ["Models"]
        ),
    ],
    dependencies: [
        .package(path: "../Utilities")
    ],
    targets: [
        .target(
            name: "Models",
            dependencies: [
                .byName(name: "Utilities")
            ],
            path: "Sources"
        ),
    ]
)
