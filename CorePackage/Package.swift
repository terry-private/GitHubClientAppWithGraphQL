// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - 📦外部パッケージ
enum ExternalPackage: String, CaseIterable {
    case 📦apollo = "apollo-ios"
    case 📦gitHubSchema = "GitHubSchema"
    
    var dependency: Package.Dependency {
        switch self {
        case .📦apollo:
            return .package(
                url: "https://github.com/apollographql/apollo-ios.git",
                .upToNextMajor(from: "1.0.0")
            )
        case .📦gitHubSchema:
            return .package(path: "GitHubSchema")
        }
    }
}

//　MARK: - 🌐外部モジュール
private extension Target.Dependency {
    static let 🌐apollo: Target.Dependency = .product(name: "Apollo", .📦apollo)
    static let 🌐apolloSQLite: Target.Dependency = .product(name: "ApolloSQLite", .📦apollo)
    static let 🌐gitHubSchema: Target.Dependency = .product(name: "GitHubSchema", .📦gitHubSchema)
}

//　MARK: - 🏠内部モジュール
enum InternalModule: String, CaseIterable {
    case 🏠productionAppFeature = "ProductionAppFeature"
    case 🏠core = "Core"
    case 🏠detail = "Detail"
    case 🏠search = "Search"
    
    var target: Target {
        switch self {
        case .🏠productionAppFeature:
            return target(
                internalModules: [
                    .🏠search,
                ],
                path: "./Sources/AppFeatures/ProductionAppFeature"
            )
        case .🏠core:
            return target(
                internalModules: [],
                externalModules: [
                    .🌐apollo,
                    .🌐apolloSQLite,
                    .🌐gitHubSchema
                ]
            )
        case .🏠detail:
            return target(
                internalModules: [
                    .🏠core
                ],
                externalModules: [],
                path: "./Sources/Features/Detail"
            )
                
        case .🏠search:
            return target(
                internalModules: [
                    .🏠core
                ],
                externalModules: [
                    .🌐apollo
                ],
                path: "./Sources/Features/Search"
            )
        }
    }
}

// MARK: - 🧪テストモジュール
enum TestModule: String, CaseIterable {
    case 🧪corePackageTests = "CorePackageTests"
    
    var target: Target {
        switch self {
        case .🧪corePackageTests:
            return testTarget(
                internalModules: [
                    .🏠core,
                    .🏠search
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
    products: InternalModule.allCases.map { .library(name: $0.rawValue, targets: [$0.rawValue])},
    dependencies: ExternalPackage.allCases.map { $0.dependency },
    targets: InternalModule.allCases.map { $0.target } + TestModule.allCases.map { $0.target }
)

// MARK: - Configure Extensions
private extension InternalModule {
    var dependency: Target.Dependency { .byName(name: self.rawValue) }
    
    func target(
        internalModules: [InternalModule] = [], // 標準メソッドに追加
        externalModules: [Target.Dependency] = [],
        path: String? = nil,
        exclude: [String] = [],
        sources: [String]? = nil,
        resources: [Resource]? = nil,
        publicHeadersPath: String? = nil,
        cSettings: [CSetting]? = nil,
        cxxSettings: [CXXSetting]? = nil,
        swiftSettings: [SwiftSetting]? = nil,
        linkerSettings: [LinkerSetting]? = nil,
        plugins: [Target.PluginUsage]? = nil
    ) -> Target {
        return Target.target(
            name: rawValue,
            dependencies: internalModules.map { $0.dependency } + externalModules,
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

private extension TestModule {
    func testTarget(
        internalModules: [InternalModule] = [], // 標準メソッドに追加
        externalModules: [Target.Dependency] = [],
        path: String? = nil,
        exclude: [String] = [],
        sources: [String]? = nil,
        resources: [Resource]? = nil,
        publicHeadersPath: String? = nil,
        cSettings: [CSetting]? = nil,
        cxxSettings: [CXXSetting]? = nil,
        swiftSettings: [SwiftSetting]? = nil,
        linkerSettings: [LinkerSetting]? = nil,
        plugins: [Target.PluginUsage]? = nil
    ) -> Target {
        return .testTarget(
            name: rawValue,
            dependencies: internalModules.map { $0.dependency } + externalModules,
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
    static func product(name: String, _ externalPackage: ExternalPackage) -> Target.Dependency {
        .product(name: name, package: externalPackage.rawValue)
    }
}
