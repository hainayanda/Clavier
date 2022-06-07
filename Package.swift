// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Clavier",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "Clavier",
            targets: ["Clavier"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.1"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "Clavier",
            dependencies: [],
            path: "Clavier/Classes"
        ),
        .testTarget(
            name: "ClavierTests",
            dependencies: [
                "Clavier", "Quick", "Nimble"
            ],
            path: "Example/Clavier"
        )
    ]
)
