import PackageDescription

let package = Package(
    name: "HTTP",
    targets: [
        Target(name: "HTTP", dependencies: ["JSON"]),
        Target(name: "Server", dependencies: ["HTTP", "JSON"]),
        Target(name: "Client", dependencies: ["HTTP"]),
    ],
    dependencies: [
        .Package(
            url: "https://github.com/swift-stack/log.git",
            majorVersion: 0,
            minor: 3
        ),
        .Package(
            url: "https://github.com/swift-stack/async.git",
            majorVersion: 0,
            minor: 3
        ),
        .Package(
            url: "https://github.com/swift-stack/network.git",
            majorVersion: 0,
            minor: 3
        ),
        .Package(
            url: "https://github.com/swift-stack/reflection.git",
            majorVersion: 0,
            minor: 3
        ),
        .Package(
            url: "https://github.com/swift-stack/fiber.git",
            majorVersion: 0,
            minor: 3
        ),
    ]
)
