# HTTP

Asynchronous HTTP server/client using [cooperative multitasking](https://github.com/swift-stack/fiber). **No callbacks.**

## Package.swift

```swift
.package(url: "https://github.com/swift-stack/http.git", .branch("dev"))
```

## Quick Start [[source](https://github.com/swift-stack/examples/tree/master/http)]

### First we need to create a root fiber and run the event loop:

```swift
// main.swift

import Fiber

async.use(Fiber.self)

async.main {
    // entry point for our async code
}

async.loop.run()
```

### Simple server running "http://localhost:8080":

```swift
// async.main {}
let server = try Server(host: "localhost", port: 8080)
try registerRoutes(in: server)
try server.start()
```

### Simple `get` route:

```swift
// routes.swift

import HTTP

func registerRoutes(in server: Server) throws {
    server.route(get: "/hello") {
        return "Hey there!"
    }
}
```

### At this point our server is ready to be friendly:

```bash
$ swift run main
$ curl http://localhost:8080/hello
> Hey there!
```

### More advanced version:

```swift
struct User: Decodable {
    let name: String
}

func helloHandler(user: User) -> String {
    return "Hello \(user.name)"
}

let application = Application(basePath: "/v1")
application.route(get: "/hello", to: helloHandler)
server.addApplication(application)
```

### Most advanced version:

```swift
struct User: Decodable {
    let name: String
}

struct Greeting: Encodable {
    let message: String
}

func helloHandler(user: User) -> Greeting {
    return .init(message: "Hello, \(user.name)!")
}

struct SwiftMiddleware: Middleware {
    static func chain(with handler: @escaping RequestHandler) -> RequestHandler {
        return { request in
            if request.url.query?["name"] == "swift" {
                return Response(string: "🤘")
            }
            return try handler(request)
        }
    }
}

let application = Application(basePath: "/v2")

application.route(
    get: "/hello",
    through: [SwiftMiddleware.self],
    to: helloHandler)

server.addApplication(application)
```

```bash
$ swift run main
$ curl http://localhost:8080/v2/hello?name=swift
> 🤘
```

### The same route using human readable urls

```swift
struct User: Decodable {
    let name: String
}

struct Greeting: Encodable {
    let message: String
}

func helloHandler(user: User) -> Greeting {
    return .init(message: "Hello, \(user.name)!")
}

struct SwiftMiddleware: Middleware {
    static func chain(with handler: @escaping RequestHandler) -> RequestHandler {
        return { request in
            if request.url.path.split(separator: "/").last == "swift" {
                return Response(string: "🤘")
            }
            return try handler(request)
        }
    }
}

let application = Application(basePath: "/v3")

application.route(
    get: "/hello/:name",
    through: [SwiftMiddleware.self],
    to: helloHandler)

server.addApplication(application)
```

```bash
$ swift run main
$ curl http://localhost:8080/v3/hello/swift
> 🤘
```
