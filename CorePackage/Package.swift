// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private extension PackageDescription.Target.Dependency {
    static let apollo: Self = .product(name: "Apollo", package: "apollo-ios")
    static let apolloSQLite: Self = .product(name: "ApolloSQLite", package: "apollo-ios")
    static let gitHubSchema: Self = .product(name: "GitHubSchema", package: "GitHubSchema")
}

let package = Package(
    name: "CorePackage",
    platforms: [
        .iOS("16.1"),
    ],
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
        .package(path: "GitHubSchema")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                .apollo,
                .apolloSQLite,
                .gitHubSchema
            ]),
        .testTarget(
            name: "CorePackageTests",
            dependencies: ["Core"]),
    ]
)
