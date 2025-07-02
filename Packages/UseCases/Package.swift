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
        .package(path: "../Network"),
        .package(path: "../Database"),
        .package(path: "../DBServices"),
        .package(path: "../APIServices"),
        .package(path: "../StorageServices"),
        .package(path: "../Entities"),
        .package(path: "../DTOs"),
        .package(path: "../Models")
    ],
    targets: [
        .target(
            name: "UseCases",
            dependencies: [
                .byName(name: "Network"),
                .byName(name: "Database"),
                .byName(name: "DBServices"),
                .byName(name: "APIServices"),
                .byName(name: "StorageServices"),
                .byName(name: "Entities"),
                .byName(name: "DTOs"),
                .byName(name: "Models")
            ],
            path: "Sources"
        ),
    ]
)
