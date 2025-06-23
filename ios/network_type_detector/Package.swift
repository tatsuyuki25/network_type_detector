// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "network_type_detector",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(
            name: "network-type-detector",
            targets: ["network_type_detector"])
    ],
    dependencies: [
        .package(url: "https://github.com/ashleymills/Reachability.swift.git", from: "5.2.4")
    ],
    targets: [
        .target(
            name: "network_type_detector",
            dependencies: [
                .product(name: "Reachability", package: "Reachability.swift")
            ],
            path: "Sources"
        )
    ]
) 