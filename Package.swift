import PackageDescription

let package = Package(
    name: "HTTPServer",
    targets: [
        Target(name: "HTTPServer", dependencies: ["HTTPMessage"])
    ],
    dependencies: [
        .Package(url: "https://github.com/swift-stack/log.git", majorVersion: 0),
        .Package(url: "https://github.com/swift-stack/async.git", majorVersion: 0),
        .Package(url: "https://github.com/swift-stack/socket.git", majorVersion: 0),
        .Package(url: "https://github.com/swift-stack/reflection.git", majorVersion: 0),
    ]
)
