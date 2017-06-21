import Test
import Server
import Client

class FunctionalTests: TestCase {
    func setup(
        port: UInt16,
        serverCode: @escaping (Server) throws -> Void,
        clientCode: @escaping (Client) throws -> Void
    ) {
        let condition = AtomicCondition()
        let async = TestAsync()

        async.task {
            do {
                let server =
                    try Server(host: "127.0.0.1", port: port, async: async)

                try serverCode(server)

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
                try client.connect(to: URL("http://127.0.0.1:\(port)/"))

                try clientCode(client)

                async.breakLoop()
            } catch {
                async.breakLoop()
                fail(String(describing: error))
            }
        }

        async.loop.run()
    }

    func testRequest() {
        setup(
            port: 6000,
            serverCode: { server in
                server.route(get: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let request = Request(method: .get, url: "/")
                let response = try client.makeRequest(request)
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testGet() {
        setup(
            port: 6001,
            serverCode: { server in
                server.route(get: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.get("/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testHead() {
        setup(
            port: 6002,
            serverCode: { server in
                server.route(head: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.head("/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testPost() {
        setup(
            port: 6003,
            serverCode: { server in
                server.route(post: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.post("/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testPut() {
        setup(
            port: 6004,
            serverCode: { server in
                server.route(put: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.put("/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testDelete() {
        setup(
            port: 6005,
            serverCode: { server in
                server.route(delete: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.delete("/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testOptions() {
        setup(
            port: 6006,
            serverCode: { server in
                server.route(options: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let response = try client.options("/")
                assertEqual(response.status, .ok)
                assertNil(response.body)
            }
        )
    }

    func testAll() {
        setup(
            port: 6007,
            serverCode: { server in
                server.route(all: "/") {
                    return Response(status: .ok)
                }
            },
            clientCode: { client in
                let getResponse = try client.get("/")
                assertEqual(getResponse.status, .ok)

                let headResponse = try client.head("/")
                assertEqual(headResponse.status, .ok)

                let postResponse = try client.post("/")
                assertEqual(postResponse.status, .ok)

                let putResponse = try client.put("/")
                assertEqual(putResponse.status, .ok)

                let deleteResponse = try client.delete("/")
                assertEqual(deleteResponse.status, .ok)

                let optionsResponse = try client.post("/")
                assertEqual(optionsResponse.status, .ok)
            }
        )
    }

    func testJson() {
        setup(
            port: 6008,
            serverCode: { server in
                struct Model: Codable {
                    var message: String
                }
                server.route(post: "/") { (model: Model) in
                    assertEqual(model.message, "Hello, Server!")
                    return Model(message: "Hello, Client!")
                }
            },
            clientCode: { client in
                let message = ["message": "Hello, Server!"]
                let response = try client.post("/", json: message)
                assertEqual(response.status, .ok)
                assertEqual(response.body, "{\"message\":\"Hello, Client!\"}")
            }
        )
    }

    func testFormEncoded() {
        setup(
            port: 6009,
            serverCode: { server in
                struct Model: Decodable {
                    var message: String
                }
                server.route(post: "/") { (model: Model) in
                    assertEqual(model.message, "Hello, Server!")
                    return Response(urlEncoded: ["message": "Hello, Client!"])
                }
            },
            clientCode: { client in
                struct Query: Encodable {
                    let message = "Hello, Server!"
                }
                let response = try client.post("/", urlEncoded: Query())
                assertEqual(response.status, .ok)
                assertEqual(response.body, "message=Hello,%20Client!")
            }
        )
    }
}
