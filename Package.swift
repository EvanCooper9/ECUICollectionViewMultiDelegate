// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ECUICollectionViewMultiDelegate",
    products: [
        .library(
            name: "ECUICollectionViewMultiDelegate",
            targets: ["ECUICollectionViewMultiDelegate"]),
    ],
    targets: [
        .target(
            name: "ECUICollectionViewMultiDelegate",
            dependencies: [],
            path: "Sources"
        )
    ]
)
