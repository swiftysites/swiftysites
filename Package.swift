// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SwiftySites",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "SwiftySites",
            targets: ["SwiftySites"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.4")),
    ],
    targets: [
        .binaryTarget(
            name: "CMarkGFM",
            url: "https://github.com/swiftysites/cmark-gfm/releases/download/1.0.0/CMarkGFM.xcframework.zip",
            checksum: "a2638dfb0d52990788143e7bbe9fdc4de1eb0153a9830a208d951720d3a4b75f"),
        .target(
            name: "SwiftySites",
            dependencies: [
                "CMarkGFM",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "SwiftySitesTests",
            dependencies: ["SwiftySites"])
    ]
)
