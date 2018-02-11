// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "HTTP",
    products: [
        .library(name: "HTTP", targets: ["HTTP"]),
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
            name: "HTTP",
            dependencies: ["Log", "Network", "Stream", "JSON", "Compression"]),
        .testTarget(
            name: "MessageTests",
            dependencies: ["HTTP", "Test"]),
        .testTarget(
            name: "MVCTests",
            dependencies: ["HTTP", "Test"]),
        .testTarget(
            name: "ServerTests",
            dependencies: ["HTTP", "Test", "AsyncDispatch"]),
        .testTarget(
            name: "ClientTests",
            dependencies: ["HTTP", "Test", "AsyncDispatch"]),
        .testTarget(
            name: "FunctionalTests",
            dependencies: ["HTTP", "Test", "AsyncDispatch"]),
        .testTarget(
            name: "KeyValueCodableTests",
            dependencies: ["HTTP", "Test"]),
    ]
)
