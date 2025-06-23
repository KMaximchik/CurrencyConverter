// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DTOs",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "DTOs",
            targets: ["DTOs"]
        ),
    ],
    targets: [
        .target(
            name: "DTOs"
        ),
    ]
)
