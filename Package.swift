// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "HTTP",
    products: [
        .library(name: "HTTP", targets: ["HTTP"]),
        .library(name: "Server", targets: ["Server"]),
        .library(name: "Client", targets: ["Client"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-stack/log.git",
            from: "0.4.0"),
        .package(
            url: "https://github.com/swift-stack/async.git",
            from: "0.4.0"),
        .package(
            url: "https://github.com/swift-stack/memory.git",
            from: "0.4.0"),
        .package(
            url: "https://github.com/swift-stack/network.git",
            from: "0.4.0"),
        .package(
            url: "https://github.com/swift-stack/json.git",
            from: "0.4.0"),
        .package(
            url: "https://github.com/swift-stack/compression.git",
            from: "0.4.0"),
        .package(
            url: "https://github.com/swift-stack/test.git",
            from: "0.4.0")
    ],
    targets: [
        .target(name: "KeyValueCodable"),
        .target(
            name: "HTTP",
            dependencies: [
                "MemoryStream", "Buffer", "JSON", "KeyValueCodable"
            ]),
        .target(
            name: "Server",
            dependencies: ["Log", "Async", "Network", "HTTP"]
        ),
        .target(
            name: "Client",
            dependencies: ["Log", "Async", "Network", "HTTP", "Compression"]
        ),
        .testTarget(name: "HTTPTests", dependencies: ["HTTP", "Test"]),
        .testTarget(
            name: "ServerTests",
            dependencies: ["Server", "Test", "AsyncDispatch"]),
        .testTarget(
            name: "ClientTests",
            dependencies: ["Client", "Test", "AsyncDispatch"]),
        .testTarget(
            name: "FunctionalTests",
            dependencies: ["Server", "Client", "Test", "AsyncDispatch"]),
        .testTarget(
            name: "KeyValueCodableTests",
            dependencies: ["KeyValueCodable", "Test"])
    ]
)
