import Test
import Network
@testable import Server

class MiddlewareTests: TestCase {
    func testMiddleware() {
        let condition = AtomicCondition()
        let async = TestAsync()

        struct TestMiddleware: Middleware {
            public static func createMiddleware(
                for handler: @escaping RequestHandler
            ) -> RequestHandler {
                return { request in
                    var response = try handler(request)
                    response.status = .ok
                    response.headers["Custom-Header"] = "Middleware"
                    return response
                }
            }
        }

        async.task {
            do {
                let server =
                    try Server(host: "127.0.0.1", port: 5001, async: async)

                server.route(
                    get: "/middleware",
                    middleware: [TestMiddleware.self]
                ) {
                    return Response(status: .internalServerError)
                }

                condition.signal()
                try server.start()
            } catch {
                fail(String(describing: error))
                async.breakLoop()
            }
        }

        condition.wait()

        async.task {
            do {
                let request = "GET /middleware HTTP/1.1\r\n\r\n"
                let expected =
                    "HTTP/1.1 200 OK\r\n" +
                    "Content-Length: 0\r\n" +
                    "Custom-Header: Middleware\r\n" +
                    "\r\n"
                var buffer = [UInt8](repeating: 0, count: 1000)

                let socket = try Socket(awaiter: async.awaiter)
                try socket.connect(to: "127.0.0.1", port: 5001)
                _ = try socket.send(bytes: [UInt8](request.utf8))
                _ = try socket.receive(to: &buffer)
                let response = String(cString: &buffer)

                assertEqual(response, expected)

                async.breakLoop()
            } catch {
                fail(String(describing: error))
                async.breakLoop()
            }
        }

        async.loop.run()
    }

    func testMiddlewareOrder() {
        let condition = AtomicCondition()
        let async = TestAsync()

        struct FirstMiddleware: Middleware {
            public static func createMiddleware(
                for handler: @escaping RequestHandler
            ) -> RequestHandler {
                return { request in
                    var response = try handler(request)
                    response.headers["Middleware"] = "first"
                    response.headers["FirstMiddleware"] = "true"
                    return response
                }
            }
        }

        struct SecondMiddleware: Middleware {
            public static func createMiddleware(
                for handler: @escaping RequestHandler
            ) -> RequestHandler {
                return { request in
                    var response = try handler(request)
                    response.headers["Middleware"] = "second"
                    response.headers["SecondMiddleware"] = "true"
                    return response
                }
            }
        }

        async.task {
            do {
                let server =
                    try Server(host: "127.0.0.1", port: 5002, async: async)

                server.route(
                    get: "/middleware",
                    middleware: [FirstMiddleware.self, SecondMiddleware.self]
                ) {
                    return Response(status: .ok)
                }

                condition.signal()
                try server.start()
            } catch {
                fail(String(describing: error))
                async.breakLoop()
            }
        }

        condition.wait()

        async.task {
            do {
                let request = "GET /middleware HTTP/1.1\r\n\r\n"
                var buffer = [UInt8](repeating: 0, count: 1000)

                let socket = try Socket(awaiter: async.awaiter)
                try socket.connect(to: "127.0.0.1", port: 5002)
                _ = try socket.send(bytes: [UInt8](request.utf8))
                _ = try socket.receive(to: &buffer)
                let response = String(cString: &buffer)

                let lines = response.components(separatedBy: "\r\n")

                let firstMiddleware = lines.first(where: {
                    return $0.hasPrefix("FirstMiddleware")
                })
                let secondMiddleware = lines.first(where: {
                    return $0.hasPrefix("SecondMiddleware")
                })
                let middleware = lines.first(where: {
                    return $0.hasPrefix("Middleware")
                })

                print(lines)

                assertEqual(firstMiddleware, "FirstMiddleware: true")
                assertEqual(secondMiddleware, "SecondMiddleware: true")
                assertEqual(middleware, "Middleware: first")

                async.breakLoop()
            } catch {
                fail(String(describing: error))
                async.breakLoop()
            }
        }

        async.loop.run()
    }
}
