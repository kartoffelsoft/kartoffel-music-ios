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
            name: "GoogleDriveFeature",
            targets: ["GoogleDriveFeature"]
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
        .library(
            name: "GoogleAuthUseCase",
            targets: ["GoogleAuthUseCase"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/google/GoogleSignIn-iOS", exact: "7.0.0"),
        .package(url: "https://github.com/google/google-api-objectivec-client-for-rest", exact: "3.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "0.50.0"),
    ],
    targets: [
        .target(
            name: "AppRootFeature",
            dependencies: [
                "LibraryFeature",
                "PlayListsFeature",
                "StyleGuide",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/Features/AppRootFeature"
        ),
        .target(
            name: "GoogleDriveFeature",
            dependencies: [
                "GoogleAuthUseCase",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
            ],
            path: "./Sources/Features/GoogleDriveFeature",
            resources: [.process("Resources/")]
        ),
        .target(
            name: "LibraryFeature",
            dependencies: [
                "GoogleDriveFeature",
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
            name: "StyleGuide",
            resources: [.process("Resources/")]
        ),
        .target(
            name: "UIKitUtils",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "GoogleAuthUseCase",
            dependencies: [
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
            ],
            path: "./Sources/UseCases/GoogleAuthUseCase"
        ),
        .testTarget(
            name: "LibraryFeatureTests",
            dependencies: ["LibraryFeature"],
            path: "./Tests/Features/LibraryFeatureTests"
        ),
    ]
)
