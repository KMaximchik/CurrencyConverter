// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Database",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Database",
            targets: ["Database"]
        ),
    ],
    targets: [
        .target(
            name: "Database",
            path: "Sources"
        ),
    ]
)
