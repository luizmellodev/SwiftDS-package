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
    targets: [
        .target(
            name: "SwiftDS",
            path: "Sources/DesignSystem"
        )
    ]
)
