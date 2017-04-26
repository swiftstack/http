import HTTP
@testable import Client
import Network

class ClientTests: TestCase {
    func testClient() {
        let condition = AtomicCondition()
        let async = TestAsync()

        async.task {
            do {
                let expected = "GET / HTTP/1.1\r\n\r\n"
                let result = "HTTP/1.1 200 OK\r\n\r\n"
                var buffer = [UInt8](repeating: 0, count: 100)

                let socket = try Socket(awaiter: async.awaiter)
                    .bind(to: "127.0.0.1", port: 5001)
                    .listen()

                condition.signal()

                let client = try socket.accept()
                let count = try client.receive(to: &buffer)
                _ = try client.send(bytes: [UInt8](result.utf8))

                let request = String(bytes: [UInt8](buffer.prefix(upTo: count)))
                assertEqual(request, expected)
            } catch {
                async.breakLoop()
                fail(String(describing: error))
            }
        }

        condition.wait()

        async.task {
            do {
                let request = Request()

                let client = try Client(async: async)
                try client.connect(to: URL("http://127.0.0.1:5001/"))
                let response = try client.makeRequest(request)

                assertEqual(response.status, .ok)
                assertNil(response.body)

                async.breakLoop()
            } catch {
                fail(String(describing: error))
            }
        }

        async.loop.run()
    }
}
