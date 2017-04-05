import XCTest
import Server
@testable import Client

class ClientTests: TestCase {
    func testClientGet() {
        let condition = AtomicCondition()
        let async = TestAsync()

        async.task {
            do {
                let server =
                    try Server(host: "127.0.0.1", port: 4001, async: async)

                server.route(get: "/") {
                    return Response(status: .ok)
                }

                condition.signal()
                try server.start()
            } catch {
                async.breakLoop()
                fail(String(describing: error))
            }
        }

        condition.wait()

        async.task {
            do {
                let client = try Client(async: async)
                try client.connect(to: "http://127.0.0.1:4001/")

                let response = try client.get("/")
                assertEqual(response.status, .ok)
                assertNil(response.body)

                async.breakLoop()
            } catch {
                fail(String(describing: error))
            }
        }

        async.loop.run()
    }

    func testClientPost() {
        let condition = AtomicCondition()
        let async = TestAsync()

        async.task {
            do {
                let server =
                    try Server(host: "127.0.0.1", port: 4002, async: async)

                server.route(post: "/") {
                    return Response(status: .ok)
                }

                condition.signal()
                try server.start()
            } catch {
                async.breakLoop()
                fail(String(describing: error))
            }
        }

        condition.wait()

        async.task {
            do {
                let client = try Client(async: async)
                try client.connect(to: "http://127.0.0.1:4002/")

                let response = try client.post("/")
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
