// swift-tools-version: 5.10
// Package.swift — Swift Package for the Design System

import PackageDescription

let package = Package(
    name: "SwiftDS",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SwiftDS",
            targets: ["SwiftDS"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.19.2"
        )
    ],
    targets: [
        .target(
            name: "SwiftDS",
            path: "Sources/DesignSystem"
        ),
        .testTarget(
            name: "SwiftDSTests",
            dependencies: [
                "SwiftDS",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/SwiftDSTests",
            exclude: ["__Snapshots__"]
        )
    ]
)
