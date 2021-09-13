// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SwiftySites",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "SwiftySites",
            targets: ["SwiftySites"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.4")),
        .package(url: "https://github.com/swiftysites/gfmarkdown", .revision("1.0.1"))
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
