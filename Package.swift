// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "HTTP",
    platforms: [
        .iOS("16"),
        .macOS("13"),
    ],
    products: [
        .library(
            name: "HTTP",
            targets: ["HTTP"]),
    ],
    dependencies: [
        .package(name: "URL"),
        .package(name: "Network"),
        .package(name: "Stream"),
        .package(name: "DCompression"),
        .package(name: "JSON"),
        .package(name: "Log"),
        .package(name: "Test"),
    ],
    targets: [
        .target(
            name: "HTTP",
            dependencies: [
                .product(name: "URL", package: "url"),
                .product(name: "JSON", package: "json"),
                .product(name: "Stream", package: "stream"),
                .product(name: "Network", package: "network"),
                .product(name: "DCompression", package: "DCompression"),
                .product(name: "Log", package: "log"),
            ],
            swiftSettings: swift6),
    ]
)

let swift6: [SwiftSetting] = [
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("StrictConcurrency"),
    .enableUpcomingFeature("ImplicitOpenExistentials"),
    .enableUpcomingFeature("BareSlashRegexLiterals"),
]

// MARK: - tests

testTarget("Client") { test in
    test("Client")
}

testTarget("Functional") { test in
    test("Functional")
}

testTarget("KeyValueCodable") { test in
    test("Decoder")
    test("Encoder")
}

testTarget("Message") { test in
    test("ChunkedStream")
    test("HeaderName")
    test("Headers+Authorization")
    test("Nginx")
    test("Request")
    test("Request+Decode")
    test("Request+Encode")
    test("Response")
    test("Response+Decode")
    test("Response+Encode")
}

testTarget("Server") { test in
    test("Application")
    test("Middleware")
    test("Router")
    test("Server")
    test("ThrowableRoute")
}

func testTarget(_ target: String, task: ((String) -> Void) -> Void) {
    task { test in addTest(target: target, name: test) }
}

func addTest(target: String, name: String) {
    package.targets.append(
        .executableTarget(
            name: "Tests/\(target)/\(name)",
            dependencies: [
                .target(name: "HTTP"),
                .product(name: "Test", package: "test"),
            ],
            path: "Tests/\(target)/\(name)",
            swiftSettings: swift6))
}

// MARK: - custom package source

#if canImport(ObjectiveC)
import Darwin.C
#else
import Glibc
#endif

extension Package.Dependency {
    enum Source: String {
        case local, remote, github

        static var `default`: Self { .github }

        var baseUrl: String {
            switch self {
            case .local: return "../"
            case .remote: return "https://swiftstack.io/"
            case .github: return "https://github.com/swiftstack/"
            }
        }

        func url(for name: String) -> String {
            return self == .local
                ? baseUrl + name.lowercased()
                : baseUrl + name.lowercased() + ".git"
        }
    }

    static func package(name: String) -> Package.Dependency {
        guard let pointer = getenv("SWIFTSTACK") else {
            return .package(name: name, source: .default)
        }
        guard let source = Source(rawValue: String(cString: pointer)) else {
            fatalError("Invalid source. Use local, remote or github")
        }
        return .package(name: name, source: source)
    }

    static func package(name: String, source: Source) -> Package.Dependency {
        return source == .local
            ? .package(name: name, path: source.url(for: name))
            : .package(url: source.url(for: name), branch: "dev")
    }
}
