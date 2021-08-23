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
            url: "https://github.com/swiftysites/cmark-gfm/releases/download/1.0.0-beta.2/CMarkGFM.xcframework.zip",
            checksum: "c17107899fa86946af719a42aae617569c85f2c0016daa1f344892a6b70df994"),
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
