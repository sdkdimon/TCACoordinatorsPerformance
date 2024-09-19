// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TCACoordinatorsPerformance",
    platforms: [
        .iOS(.v15)
      ],
    products: [
        .library(name: "ObservableState", targets: ["ObservableState"]),
        .library(name: "UnobservableState", targets: ["UnobservableState"]),
        .library(name: "Helpers", targets: ["Helpers"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "main"),
        .package(path: "TCACoordinators"),
      ],
    targets: [
        .target(
            name: "ObservableState",
            dependencies: [
              "Helpers",
              .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
              .product(name: "TCACoordinators", package: "TCACoordinators"),
            ]
        ),
        .target(
            name: "UnobservableState",
            dependencies: [
              "Helpers",
              .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
              .product(name: "TCACoordinators", package: "TCACoordinators"),
            ]
        ),
        .target(name: "Helpers")
    ]
)
