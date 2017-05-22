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
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/swift-stack/async.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/swift-stack/network.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/swift-stack/reflection.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/swift-stack/fiber.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/swift-stack/test.git",
            from: "0.4.0"
        )
    ],
    targets: [
        .target(name: "JSON"),
        .target(name: "HTTP", dependencies: ["JSON"]),
        .target(
            name: "Server",
            dependencies: ["Async", "Network", "HTTP", "Reflection", "Log"]
        ),
        .target(
            name: "Client",
            dependencies: ["Async", "Network", "HTTP", "Log"]
        ),
        .testTarget(name: "JSONTests", dependencies: ["JSON", "Test"]),
        .testTarget(name: "HTTPTests", dependencies: ["HTTP", "Test"]),
        .testTarget(name: "ServerTests", dependencies: ["Server", "Test"]),
        .testTarget(name: "ClientTests", dependencies: ["Client", "Test"]),
        .testTarget(
            name: "FunctionalTests",
            dependencies: ["Server", "Client", "Test"]
        )
    ]
)
