// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - 外部パッケージ
enum ExternalPackage: CaseIterable {
    case apollo
    case gitHubSchema
    
    var dependency: Dependency {
        switch self {
        case .apollo:
            return .init(
                name: "apollo-ios",
                package: .package(
                    url: "https://github.com/apollographql/apollo-ios.git",
                    .upToNextMajor(from: "1.0.0")
                )
            )
        case .gitHubSchema:
            return .init(
                name: "GitHubSchema",
                package: .package(path: "GitHubSchema")
            )
        }
    }
    
    struct Dependency {
        var name: String
        var package: Package.Dependency
    }
}

//　MARK: - 外部モジュール
private extension Target.Dependency {
    static let apollo: Target.Dependency = .product(name: "Apollo", .apollo)
    static let apolloSQLite: Target.Dependency = .product(name: "ApolloSQLite", .apollo)
    static let gitHubSchema: Target.Dependency = .product(name: "GitHubSchema", .gitHubSchema)
}

//　MARK: - 内部モジュール
enum DependencyModule: String, CaseIterable {
    case core = "Core"
    
    var target: Target {
        switch self {
        case .core:
            return .target(
                name: rawValue,
                dependencyModules: [
                ],
                dependencies: [
                    .apollo,
                    .apolloSQLite,
                    .gitHubSchema
                ]
            )
        }
    }
}

let package = Package(
    name: "CorePackage",
    platforms: [
        .iOS("16.1"),
    ],
    products: DependencyModule.allCases.map { .library(name: $0.rawValue, targets: [$0.rawValue])},
    dependencies: ExternalPackage.allCases.map { $0.dependency.package },
    targets: DependencyModule.allCases.map { $0.target }
)

// MARK: - Configure Extensions
private extension DependencyModule {
    var dependency: Target.Dependency { .byName(name: self.rawValue) }
}

private extension Target {
    static func target(
        name: String,
        dependencyModules: [DependencyModule] = [], // 標準メソッドに追加
        dependencies: [Dependency] = [],
        path: String? = nil,
        exclude: [String] = [],
        sources: [String]? = nil,
        resources: [Resource]? = nil,
        publicHeadersPath: String? = nil,
        cSettings: [CSetting]? = nil,
        cxxSettings: [CXXSetting]? = nil,
        swiftSettings: [SwiftSetting]? = nil,
        linkerSettings: [LinkerSetting]? = nil,
        plugins: [PluginUsage]? = nil
    ) -> Target {
        return Target.target(
            name: name,
            dependencies: dependencyModules.map { $0.dependency } + dependencies,
            path: path,
            exclude: exclude,
            sources: sources,
            resources: resources,
            publicHeadersPath: publicHeadersPath,
            cSettings: cSettings,
            cxxSettings: cxxSettings,
            swiftSettings: swiftSettings,
            linkerSettings: linkerSettings,
            plugins: plugins
        )
    }
}

private extension Target.Dependency {
    static func product(name: String, _ externalPackage: ExternalPackage) -> PackageDescription.Target.Dependency {
        .product(name: name, package: externalPackage.dependency.name)
    }
}
