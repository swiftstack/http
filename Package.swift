// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "HTTP",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
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
                "URL", "Network", "Stream", "JSON", "DCompression", "Log"
            ]),
    ]
)

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
            dependencies: ["HTTP", "Test"],
            path: "Tests/\(target)/\(name)"))
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

        static var `default`: Self { .local }

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
            : .package(name: name, url: source.url(for: name), .branch("dev"))
    }
}
