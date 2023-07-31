// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private extension PackageDescription.Target.Dependency {
    static let apollo: Self = .product(name: "Apollo", package: "apollo-ios")
}

let package = Package(
    name: "CorePackage",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Core",
            targets: ["Core"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apollographql/apollo-ios.git",
            .upToNextMajor(from: "1.0.0")
        ),
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                .apollo
            ]),
        .testTarget(
            name: "CorePackageTests",
            dependencies: ["Core"]),
    ]
)
