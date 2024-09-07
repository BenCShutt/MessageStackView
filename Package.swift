// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MessageStackView",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MessageStackView",
            targets: ["MessageStackView"]
        )
    ],
    targets: [
        .target(
            name: "MessageStackView",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "MessageStackViewTests",
            dependencies: ["MessageStackView"]
        )
    ]
)
