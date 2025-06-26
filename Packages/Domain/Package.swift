// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]
        ),
    ],
    dependencies: [
        .package(path: "../Utilities")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                .byName(name: "Utilities")
            ],
            path: "Sources"
        ),
    ]
)
