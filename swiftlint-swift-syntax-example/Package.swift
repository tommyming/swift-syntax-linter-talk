// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLintSwiftSyntaxExample",
    platforms: [
        .macOS(.v12),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .executable(
            name: "SwiftLintAnalyzer",
            targets: ["SwiftLintAnalyzer"]
        ),
        .library(
            name: "SwiftLintSwiftSyntaxExample",
            targets: ["SwiftLintSwiftSyntaxExample"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftLintSwiftSyntaxExample",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ]
        ),
        .executableTarget(
            name: "SwiftLintAnalyzer",
            dependencies: [
                "SwiftLintSwiftSyntaxExample",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "SwiftLintSwiftSyntaxExampleTests",
            dependencies: [
                "SwiftLintSwiftSyntaxExample",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ]
        ),
    ]
)
