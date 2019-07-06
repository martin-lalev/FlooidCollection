// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "FlooidCollection",
    platforms: [.iOS(.v10)],
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
            path: "FlooidCollection"),
    ]
)
