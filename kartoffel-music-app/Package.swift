// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "kartoffel-music-app",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AppRootFeature",
            targets: ["AppRootFeature"]
        ),
        .library(
            name: "FilesFeature",
            targets: ["FilesFeature"]
        ),
        .library(
            name: "PlayListsFeature",
            targets: ["PlayListsFeature"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "0.50.0"),
    ],
    targets: [
        .target(
            name: "AppRootFeature",
            dependencies: [
                "FilesFeature",
                "PlayListsFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "./Sources/Features/AppRootFeature"
        ),
        .target(
            name: "FilesFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "./Sources/Features/FilesFeature"
        ),
        .target(
            name: "PlayListsFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "./Sources/Features/PlayListsFeature"
        ),
        .testTarget(
            name: "FilesFeatureTests",
            dependencies: ["FilesFeature"],
            path: "./Tests/Features/FilesFeatureTests"
        ),
    ]
)
