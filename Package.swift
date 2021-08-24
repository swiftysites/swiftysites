// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftySites",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "SwiftySites",
            targets: ["SwiftySites"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "CMarkGFM",
            url: "https://github.com/swiftysites/cmark-gfm/releases/download/1.0.0/CMarkGFM.xcframework.zip",
            checksum: "a2638dfb0d52990788143e7bbe9fdc4de1eb0153a9830a208d951720d3a4b75f"),
        .target(
            name: "SwiftySites",
            dependencies: ["CMarkGFM"]),
        .testTarget(
            name: "SwiftySitesTests",
            dependencies: ["SwiftySites"]),
        .target(
            name: "Samples",
            dependencies: ["SwiftySites"]),
    ]
)
