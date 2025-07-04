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
        .package(path: "../Models"),
        .package(path: "../Utilities"),
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "DBServices",
            dependencies: [
                .byName(name: "Database"),
                .byName(name: "Entities"),
                .byName(name: "Models"),
                .byName(name: "Utilities"),
                .byName(name: "Core")
            ],
            path: "Sources"
        ),
    ]
)
