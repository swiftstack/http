import XCTest
@testable import Server
import Socket

class ServerTests: TestCase {
    func testServer() {
        let condition = AtomicCondition()
        let async = TestAsync()
        var routed = false

        async.task {
            do {
                let server =
                    try Server(host: "127.0.0.1", port: 4001, async: async)

                server.route(get: "/test") {
                    routed = true
                }

                condition.signal()
                try server.start()
            } catch {
                fail(String(describing: error))
            }
        }

        condition.wait()

        var response = ""

        async.task {
            do {
                let socket = try Socket(awaiter: async.awaiter)
                try socket.connect(to: "127.0.0.1", port: 4001)
                let request = [UInt8]("GET /test HTTP/1.1\r\n\r\n".utf8)
                _ = try socket.send(bytes: request)
                var buffer = [UInt8](repeating: 0, count: 100)
                _ = try socket.receive(to: &buffer)
                response = String(cString: &buffer)
                async.breakLoop()
            } catch {
                fail(String(describing: error))
            }
        }

        async.loop.run()

        assertTrue(routed)
        assertEqual(response, "HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n")
    }
}
