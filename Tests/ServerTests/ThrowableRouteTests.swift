import Test
import Server
import Client
import Dispatch
import AsyncDispatch

extension String: Error {}

func makeMistake() throws {
    throw "expected failure"
}

class ThrowableRouteTests: TestCase {
    override func setUp() {
        AsyncDispatch().registerGlobal()
    }

    func setup(
        port: Int,
        serverCode: @escaping (Server) throws -> Void,
        clientCode: @escaping (Client) throws -> Void
    ) {
        let semaphore = DispatchSemaphore(value: 0)

        async.task {
            do {
                let server = try Server(host: "127.0.0.1", port: port)

                try serverCode(server)

                semaphore.signal()
                try server.start()
            } catch {
                fail(String(describing: error))
            }
            async.loop.terminate()
        }

        semaphore.wait()

        async.task {
            do {
                let client = Client(host: "127.0.0.1", port: Int(port))
                try client.connect()

                try clientCode(client)
            } catch {
                fail(String(describing: error))
            }
            async.loop.terminate()
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
                let response = try client.get(path: "/")
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
                let response = try client.head(path: "/")
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
                let response = try client.post(path: "/")
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
                let response = try client.put(path: "/")
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
                let response = try client.delete(path: "/")
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
                let response = try client.options(path: "/")
                assertEqual(response.status, .internalServerError)
            }
        )
    }
}
