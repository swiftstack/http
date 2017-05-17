import XCTest
@testable import Server
import Network

class MiddlewareTests: TestCase {
    func testMiddleware() {
        let condition = AtomicCondition()
        let async = TestAsync()

        struct TestMiddleware: Middleware {
            public static func createMiddleware(
                for handler: @escaping Server.RequestHandler
            ) -> Server.RequestHandler {
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
                    try Server(host: "127.0.0.1", port: 4002, async: async)

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
                var buffer = [UInt8](repeating: 0, count: 100)

                let socket = try Socket(awaiter: async.awaiter)
                try socket.connect(to: "127.0.0.1", port: 4002)
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
}
