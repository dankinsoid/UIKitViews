// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "${NAME}",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "${NAME}", targets: ["${NAME}"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "${NAME}",
            dependencies: [
            ]
        )
    ]
)
