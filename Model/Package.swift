// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Model",
            targets: ["Model"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Model",
            dependencies: []),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Model"])
    ]
)
