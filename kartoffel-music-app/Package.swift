// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "kartoffel-music-app",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CommonModels",
            targets: ["CommonModels"]
        ),
        .library(
            name: "CommonViews",
            targets: ["CommonViews"]
        ),
        
        .library(
            name: "AudioFileManager",
            targets: ["AudioFileManager"]
        ),
        .library(
            name: "AudioPlayer",
            targets: ["AudioPlayer"]
        ),
        .library(
            name: "AudioPlayListManager",
            targets: ["AudioPlayListManager"]
        ),
        .library(
            name: "CoreDataManager",
            targets: ["CoreDataManager"]
        ),

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
            name: "AudioFileCreateUseCase",
            targets: ["AudioFileCreateUseCase"]
        ),
        .library(
            name: "AudioFileDeleteUseCase",
            targets: ["AudioFileDeleteUseCase"]
        ),
        .library(
            name: "AudioFileReadAllUseCase",
            targets: ["AudioFileReadAllUseCase"]
        ),
        .library(
            name: "AudioFileReadUseCase",
            targets: ["AudioFileReadUseCase"]
        ),
        .library(
            name: "AudioPlayUseCase",
            targets: ["AudioPlayUseCase"]
        ),
        .library(
            name: "AudioStopUseCase",
            targets: ["AudioStopUseCase"]
        ),
        .library(
            name: "GoogleDriveUseCase",
            targets: ["GoogleDriveUseCase"]
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
            name: "CommonModels"
        ),
        .target(
            name: "CommonViews",
            dependencies: [
                "CommonModels",
                "StyleGuide",
            ]
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
            name: "AudioPlayer",
            dependencies: [
            ],
            path: "./Sources/Services/AudioPlayer"
        ),
        .target(
            name: "AudioPlayListManager",
            dependencies: [
                "CoreDataManager"
            ],
            path: "./Sources/Services/AudioPlayListManager"
        ),
        .target(
            name: "CoreDataManager",
            dependencies: [
            ],
            path: "./Sources/Services/CoreDataManager",
            resources: [.process("Resources/")]
        ),
        
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
                "CommonModels",
                "AudioFileDeleteUseCase",
                "AudioFileReadUseCase",
                "StyleGuide",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/Features/AudioFileOptionsFeature"
        ),
        .target(
            name: "GoogleDriveFeature",
            dependencies: [
                "CommonModels",
                "AudioFileCreateUseCase",
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
                "AudioFileReadAllUseCase",
                "AudioPlayUseCase",
                "AudioStopUseCase",
                "CommonModels",
                "CommonViews",
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
            name: "AudioFileCreateUseCase",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/UseCases/AudioFileCreateUseCase"
        ),
        .target(
            name: "AudioFileDeleteUseCase",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/UseCases/AudioFileDeleteUseCase"
        ),
        .target(
            name: "AudioFileReadAllUseCase",
            dependencies: [
                "AudioFileManager",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/UseCases/AudioFileReadAllUseCase"
        ),
        .target(
            name: "AudioFileReadUseCase",
            dependencies: [
                "AudioFileManager",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/UseCases/AudioFileReadUseCase"
        ),
        .target(
            name: "AudioPlayUseCase",
            dependencies: [
                "AudioPlayer",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/UseCases/AudioPlayUseCase"
        ),
        .target(
            name: "AudioStopUseCase",
            dependencies: [
                "AudioPlayer",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "./Sources/UseCases/AudioStopUseCase"
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
