import Test
import Network
import Dispatch
import AsyncDispatch

@testable import Server

class ServerTests: TestCase {
    override func setUp() {
        AsyncDispatch().registerGlobal()
    }

    func testServer() {
        let semaphore = DispatchSemaphore(value: 0)

        async.task {
            do {
                let server = try Server(host: "127.0.0.1", port: 4001)

                server.route(get: "/test") {
                    return Response(status: .ok)
                }

                semaphore.signal()
                try server.start()
            } catch {
                fail(String(describing: error))
                async.loop.terminate()
            }
        }

        semaphore.wait()

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

                async.loop.terminate()
            } catch {
                fail(String(describing: error))
                async.loop.terminate()
            }
        }

        async.loop.run()
    }

    func testBufferSize() {
        do {
            let server = try Server(
                host: "0.0.0.0",
                port: 4002)

            server.bufferSize = 16384
            assertEqual(server.bufferSize, 16384)
        } catch {
            fail(String(describing: error))
        }
    }

    func testDescription() {
        do {
            let server = try Server(
                host: "127.0.0.1",
                port: 4004)

            assertEqual(server.description, "server at http://127.0.0.1:4004")
        } catch {
            fail(String(describing: error))
        }
    }
}
