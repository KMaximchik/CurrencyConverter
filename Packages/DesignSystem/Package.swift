// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "DesignSystem",
            type: .dynamic,
            targets: ["DesignSystem"]
        ),
    ],
    targets: [
        .target(
            name: "DesignSystem",
            resources: [
                .process("Resources/Colors.xcassets")
            ]
        ),
    ]
)
