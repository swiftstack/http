import Test
@testable import Server
import Network

class ServerTests: TestCase {
    override func setUp() {
        if async == nil {
            TestAsync().registerGlobal()
        }
    }

    func testServer() {
        let condition = AtomicCondition()

        async.task {
            do {
                let server =
                    try Server(host: "127.0.0.1", port: 4001)

                server.route(get: "/test") {
                    return Response(status: .ok)
                }

                condition.signal()
                try server.start()
            } catch {
                fail(String(describing: error))
                (async.loop as! TestAsyncLoop).stop()
            }
        }

        condition.wait()

        async.task {
            do {
                let request = "GET /test HTTP/1.1\r\n\r\n"
                let expected = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n"
                var buffer = [UInt8](repeating: 0, count: 100)

                let socket = try Socket()
                try socket.connect(to: "127.0.0.1", port: 4001)
                _ = try socket.send(bytes: [UInt8](request.utf8))
                _ = try socket.receive(to: &buffer)
                let response = String(cString: &buffer)

                assertEqual(response, expected)

                (async.loop as! TestAsyncLoop).stop()
            } catch {
                fail(String(describing: error))
                (async.loop as! TestAsyncLoop).stop()
            }
        }

        async.loop.run()
    }

    func testServerBufferSize() {
        do {
            let server = try Server(
                host: "0.0.0.0",
                port: 4002)

            server.bufferSize = 16 * 1024
            assertEqual(server.bufferSize, 16 * 1024)
        } catch {
            fail(String(describing: error))
        }
    }
}
