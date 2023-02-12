// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "kartoffel-music-app",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "AppRootFeature",
            targets: ["AppRootFeature"]
        ),
        .library(
            name: "LibraryFeature",
            targets: ["LibraryFeature"]
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
                "LibraryFeature",
                "PlayListsFeature",
                "StyleGuide",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "./Sources/Features/AppRootFeature"
        ),
        .target(
            name: "LibraryFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "./Sources/Features/LibraryFeature",
            resources: [.process("Resources/")]
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
            name: "LibraryFeatureTests",
            dependencies: ["LibraryFeature"],
            path: "./Tests/Features/LibraryFeatureTests"
        ),
    ]
)
