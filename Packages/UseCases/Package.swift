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
        .package(path: "../APIServices"),
        .package(path: "../StorageServices"),
        .package(path: "../Entities"),
        .package(path: "../DTOs"),
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "UseCases",
            dependencies: [
                .byName(name: "DBServices"),
                .byName(name: "APIServices"),
                .byName(name: "StorageServices"),
                .byName(name: "Entities"),
                .byName(name: "DTOs"),
                .byName(name: "Domain")
            ],
            path: "Sources"
        ),
    ]
)
