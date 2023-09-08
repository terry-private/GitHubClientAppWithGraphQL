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
    case productionAppFeature = "ProductionAppFeature"
    case core = "Core"
    case search = "Search"
    
    var target: Target {
        switch self {
        case .productionAppFeature:
            return .target(
                name: rawValue,
                dependencyModules: [
                    .search
                ],
                path: "./Sources/AppFeatures/ProductionAppFeature"
            )
        case .core:
            return .target(
                name: rawValue,
                dependencyModules: [],
                dependencies: [
                    .apollo,
                    .apolloSQLite,
                    .gitHubSchema
                ]
            )
        case .search:
            return .target(
                name: rawValue,
                dependencyModules: [
                    .core
                ],
                dependencies: [
                    .apollo
                ],
                path: "./Sources/Features/Search"
            )
        }
    }
}
    
enum TestModule: String, CaseIterable {
    case corePackageTests = "CorePackageTests"
    
    var target: Target {
        switch self {
        case .corePackageTests:
            return .testTarget(
                name: rawValue,
                dependencyModules: [
                    .core,
                    .search
                ]
            )
        }
    }
}

let package = Package(
    name: "CorePackage",
    platforms: [
        .iOS("16.1"),
        .macOS("13.3")
    ],
    products: DependencyModule.allCases.map { .library(name: $0.rawValue, targets: [$0.rawValue])},
    dependencies: ExternalPackage.allCases.map { $0.dependency.package },
    targets: DependencyModule.allCases.map { $0.target } + TestModule.allCases.map { $0.target }
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
    
    static func testTarget(
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
        return .testTarget(
            name: name,
            dependencies: dependencyModules.map { $0.dependency } + dependencies,
            path: path,
            exclude: exclude,
            sources: sources,
            resources: resources,
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
