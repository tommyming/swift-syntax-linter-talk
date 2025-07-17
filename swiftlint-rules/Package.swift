// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLintRules",
    platforms: [
        .macOS(.v12),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "SwiftLintRules",
            targets: ["SwiftLintRules"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0"),
        // Note: SwiftLint dependency commented out for demonstration
        // .package(url: "https://github.com/realm/SwiftLint.git", from: "0.57.0"),
    ],
    targets: [
        .target(
            name: "SwiftLintRules",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                // Note: SwiftLint dependencies commented out for demonstration
                // .product(name: "SwiftLintCore", package: "SwiftLint"),
                // .product(name: "SwiftLintFramework", package: "SwiftLint"),
            ]
        ),
        .testTarget(
            name: "SwiftLintRulesTests",
            dependencies: [
                "SwiftLintRules",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                // Note: SwiftLint dependencies commented out for demonstration
                // .product(name: "SwiftLintCore", package: "SwiftLint"),
                // .product(name: "SwiftLintFramework", package: "SwiftLint"),
                // .product(name: "SwiftLintTestHelpers", package: "SwiftLint"),
            ]
        ),
    ]
)
