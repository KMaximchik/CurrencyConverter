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
        .package(path: "../Database"),
        .package(path: "../Entities"),
        .package(path: "../Domain"),
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "DBServices",
            dependencies: [
                .byName(name: "Database"),
                .byName(name: "Entities"),
                .byName(name: "Domain"),
                .byName(name: "Core")
            ],
            path: "Sources"
        ),
    ]
)
