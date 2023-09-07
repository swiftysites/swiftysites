// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SwiftySites",
    platforms: [.macOS(.v13)],
    products: [
        .library(
            name: "SwiftySites",
            targets: ["SwiftySites"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/swiftysites/gfmarkdown", branch: "release")
    ],
    targets: [
        .target(
            name: "SwiftySites",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "GFMarkdown", package: "gfmarkdown")
            ]),
        .testTarget(
            name: "SwiftySitesTests",
            dependencies: ["SwiftySites"])
    ]
)
