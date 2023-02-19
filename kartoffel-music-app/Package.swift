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
            name: "CommonModels",
            targets: ["CommonModels"]
        ),
        .library(
            name: "GoogleDriveUseCase",
            targets: ["GoogleDriveUseCase"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/google/google-api-objectivec-client-for-rest", exact: "3.0.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", exact: "7.0.0"),
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
                "CommonModels",
                "GoogleDriveUseCase",
                "StyleGuide",
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
            name: "CommonModels"
        ),
        .target(
            name: "GoogleDriveUseCase",
            dependencies: [
                "CommonModels",
                .product(
                    name: "GoogleAPIClientForREST_Drive",
                    package: "google-api-objectivec-client-for-rest"
                ),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/UseCases/GoogleDriveUseCase"
        ),
        .testTarget(
            name: "LibraryFeatureTests",
            dependencies: ["LibraryFeature"],
            path: "./Tests/Features/LibraryFeatureTests"
        ),
    ]
)
