// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "kartoffel-music-app",
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
        
    ],
    targets: [
        .target(
            name: "AppRootFeature",
            dependencies: [],
            path: "./Sources/Features/AppRootFeature"
        ),
        .target(
            name: "FilesFeature",
            dependencies: [],
            path: "./Sources/Features/FilesFeature"
        ),
        .target(
            name: "PlayListsFeature",
            dependencies: [],
            path: "./Sources/Features/PlayListsFeature"
        ),
        .testTarget(
            name: "FilesFeatureTests",
            dependencies: ["FilesFeature"],
            path: "./Tests/Features/FilesFeatureTests"
        ),
    ]
)
