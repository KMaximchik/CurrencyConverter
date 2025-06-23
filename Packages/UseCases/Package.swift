// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "UseCases",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "UseCases",
            targets: ["UseCases"]
        ),
    ],
    dependencies: [
        .package(path: "../DBServices"),
        .package(path: "../APIServices")
    ],
    targets: [
        .target(
            name: "UseCases",
            dependencies: [
                .byName(name: "DBServices"),
                .byName(name: "APIServices")
            ],
            path: "Sources"
        ),
    ]
)
