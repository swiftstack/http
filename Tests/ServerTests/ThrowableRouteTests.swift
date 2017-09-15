import Test
import Server
import Client
import Dispatch
import AsyncDispatch

extension String: Error {}

func makeMistake() throws {
    throw "mistake"
}

class ThrowableRouteTests: TestCase {
    override func setUp() {
        AsyncDispatch().registerGlobal()
    }

    func setup(
        port: UInt16,
        serverCode: @escaping (Server) throws -> Void,
        clientCode: @escaping (Client) throws -> Void
    ) {
        let semaphore = DispatchSemaphore(value: 0)

        async.task {
            do {
                let server =
                    try Server(host: "127.0.0.1", port: port)

                try serverCode(server)

                semaphore.signal()
                try server.start()
            } catch {
                async.loop.terminate()
                fail(String(describing: error))
            }
        }

        semaphore.wait()

        async.task {
            do {
                let client = try Client()
                try client.connect(to: URL("http://127.0.0.1:\(port)/"))

                try clientCode(client)

                async.loop.terminate()
            } catch {
                fail(String(describing: error))
            }
        }

        async.loop.run()
    }

    func testRequest() {
        setup(
            port: 4100,
            serverCode: { server in
                server.route(get: "/") {
                    try makeMistake()
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let request = Request(method: .get, url: "/")
                let response = try client.makeRequest(request)
                assertEqual(response.status, .internalServerError)
            }
        )
    }

    func testGet() {
        setup(
            port: 4101,
            serverCode: { server in
                server.route(get: "/") {
                    try makeMistake()
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.get("/")
                assertEqual(response.status, .internalServerError)
            }
        )
    }

    func testHead() {
        setup(
            port: 4102,
            serverCode: { server in
                server.route(head: "/") {
                    try makeMistake()
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.head("/")
                assertEqual(response.status, .internalServerError)
            }
        )
    }

    func testPost() {
        setup(
            port: 4103,
            serverCode: { server in
                server.route(post: "/") {
                    try makeMistake()
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.post("/")
                assertEqual(response.status, .internalServerError)
            }
        )
    }

    func testPut() {
        setup(
            port: 4104,
            serverCode: { server in
                server.route(put: "/") {
                    try makeMistake()
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.put("/")
                assertEqual(response.status, .internalServerError)
            }
        )
    }

    func testDelete() {
        setup(
            port: 4105,
            serverCode: { server in
                server.route(delete: "/") {
                    try makeMistake()
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.delete("/")
                assertEqual(response.status, .internalServerError)
            }
        )
    }

    func testOptions() {
        setup(
            port: 4106,
            serverCode: { server in
                server.route(options: "/") {
                    try makeMistake()
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.options("/")
                assertEqual(response.status, .internalServerError)
            }
        )
    }
}
