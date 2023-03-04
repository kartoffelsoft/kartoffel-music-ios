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
            name: "AudioFileOptionsFeature",
            targets: ["AudioFileOptionsFeature"]
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
            name: "FileCreateUseCase",
            targets: ["FileCreateUseCase"]
        ),
        .library(
            name: "FileListReadUseCase",
            targets: ["FileListReadUseCase"]
        ),
        .library(
            name: "GoogleDriveUseCase",
            targets: ["GoogleDriveUseCase"]
        ),
        
        .library(
            name: "AudioFileManager",
            targets: ["AudioFileManager"]
        ),
        
        .library(
            name: "CommonModels",
            targets: ["CommonModels"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/google/google-api-objectivec-client-for-rest", exact: "3.0.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", exact: "7.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "0.50.0"),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", exact: "0.6.0"),
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
            name: "AudioFileOptionsFeature",
            dependencies: [
                "StyleGuide",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/Features/AudioFileOptionsFeature"
        ),
        .target(
            name: "GoogleDriveFeature",
            dependencies: [
                "CommonModels",
                "FileCreateUseCase",
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
                "AudioFileOptionsFeature",
                "FileListReadUseCase",
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
            name: "FileCreateUseCase",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/UseCases/FileCreateUseCase"
        ),
        .target(
            name: "FileListReadUseCase",
            dependencies: [
                "AudioFileManager",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/UseCases/FileListReadUseCase"
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
        
        .target(
            name: "AudioFileManager",
            dependencies: [
                "CommonModels",
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
            ],
            path: "./Sources/Services/AudioFileManager"
        ),
        
        .target(
            name: "CommonModels"
        ),
        
        .testTarget(
            name: "LibraryFeatureTests",
            dependencies: ["LibraryFeature"],
            path: "./Tests/Features/LibraryFeatureTests"
        ),
        
    ]
)
