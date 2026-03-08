// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "ViewModel",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "ViewModel",
            targets: ["ViewModel"])
    ],
    dependencies: [
        .package(path: "../Model")
    ],
    targets: [
        .target(
            name: "ViewModel",
            dependencies: ["Model"]),
        .testTarget(
            name: "ViewModelTests",
            dependencies: ["ViewModel"])
    ]
)
