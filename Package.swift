// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SwiftySites",
    platforms: [.macOS(.v14)],
    products: [
        .library(
            name: "SwiftySites",
            targets: ["SwiftySites"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/swiftysites/gfmarkdown", branch: "release"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SwiftySites",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "GFMarkdown", package: "gfmarkdown")
            ]
        ),
        .testTarget(
            name: "SwiftySitesTests",
            dependencies: ["SwiftySites"])
    ]
)
