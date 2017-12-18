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
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/async.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/stream.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/network.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/json.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/compression.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/test.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "KeyValueCodable"),
        .target(
            name: "HTTP",
            dependencies: ["Stream", "JSON", "KeyValueCodable", "Network"]),
        .target(
            name: "Server",
            dependencies: ["Log", "Async", "Network", "HTTP"]),
        .target(
            name: "Client",
            dependencies: ["Log", "Async", "Network", "HTTP", "Compression"]),
        .testTarget(
            name: "HTTPTests",
            dependencies: ["HTTP", "Test"]),
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
