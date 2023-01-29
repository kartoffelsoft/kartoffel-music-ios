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
            name: "PlayListCreateFeature",
            targets: ["PlayListCreateFeature"]
        ),
        .library(
            name: "PlayListsFeature",
            targets: ["PlayListsFeature"]
        ),
        .library(
            name: "StyleGuide",
            targets: ["StyleGuide"]
        ),
        .library(
            name: "UIKitUtils",
            targets: ["UIKitUtils"]
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
                "StyleGuide",
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
            name: "PlayListCreateFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "./Sources/Features/PlayListCreateFeature"
        ),
        .target(
            name: "PlayListsFeature",
            dependencies: [
                "PlayListCreateFeature",
                "StyleGuide",
                "UIKitUtils",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "./Sources/Features/PlayListsFeature"
        ),
        .target(
            name: "UIKitUtils",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "StyleGuide",
            resources: [.process("Resources/")]
        ),
        .testTarget(
            name: "FilesFeatureTests",
            dependencies: ["FilesFeature"],
            path: "./Tests/Features/FilesFeatureTests"
        ),
    ]
)
