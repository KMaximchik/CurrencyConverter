// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Entities",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Entities",
            targets: ["Entities"]
        ),
    ],
    targets: [
        .target(
            name: "Entities"
        ),
    ]
)
