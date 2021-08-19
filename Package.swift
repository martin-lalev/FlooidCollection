// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FlooidCollection",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "FlooidCollection",
            targets: ["FlooidCollection"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FlooidCollection",
            path: "FlooidCollection/Source"
        ),
    ]
)
