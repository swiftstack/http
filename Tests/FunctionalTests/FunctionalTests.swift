import Test
import HTTP
import Async

class FunctionalTests: TestCase {
    func setup(
        port: Int,
        serverCode: @escaping (Server) throws -> Void,
        clientCode: @escaping (Client) throws -> Void
    ) {
        async {
            scope {
                let server = try Server(host: "127.0.0.1", port: port)

                try serverCode(server)

                try server.start()
            }
            loop.terminate()
        }

        async {
            scope {
                let client = Client(host: "127.0.0.1", port: port)
                try client.connect()

                try clientCode(client)
            }
            loop.terminate()
        }

        loop.run()
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
                let request = Request(url: "/", method: .get)
                let response = try client.makeRequest(request)
                expect(response.status == .ok)
                expect(response.string == nil)
                expect(response.body == .none)
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
                let response = try client.get(path: "/")
                expect(response.status == .ok)
                expect(response.string == nil)
                expect(response.body == .none)
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
                let response = try client.head(path: "/")
                expect(response.status == .ok)
                expect(response.string == nil)
                expect(response.body == .none)
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
                let response = try client.post(path: "/")
                expect(response.status == .ok)
                expect(response.string == nil)
                expect(response.body == .none)
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
                let response = try client.put(path: "/")
                expect(response.status == .ok)
                expect(response.string == nil)
                expect(response.body == .none)
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
                let response = try client.delete(path: "/")
                expect(response.status == .ok)
                expect(response.string == nil)
                expect(response.body == .none)
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
                let response = try client.options(path: "/")
                expect(response.status == .ok)
                expect(response.string == nil)
                expect(response.body == .none)
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
                let getResponse = try client.get(path: "/")
                expect(getResponse.status == .ok)

                let headResponse = try client.head(path: "/")
                expect(headResponse.status == .ok)

                let postResponse = try client.post(path: "/")
                expect(postResponse.status == .ok)

                let putResponse = try client.put(path: "/")
                expect(putResponse.status == .ok)

                let deleteResponse = try client.delete(path: "/")
                expect(deleteResponse.status == .ok)

                let optionsResponse = try client.post(path: "/")
                expect(optionsResponse.status == .ok)
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
                server.route(post: "/") { (model: Model) -> Model in
                    expect(model.message == "Hello, Server!")
                    return Model(message: "Hello, Client!")
                }
            },
            clientCode: { client in
                let message = ["message": "Hello, Server!"]
                let response = try client.post(path: "/", object: message)
                expect(response.status == .ok)
                expect(response.string == "{\"message\":\"Hello, Client!\"}")
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
                server.route(post: "/") { (model: Model) -> Response in
                    expect(model.message == "Hello, Server!")
                    return try Response(
                        body: ["message": "Hello, Client!"],
                        contentType: .formURLEncoded)
                }
            },
            clientCode: { client in
                struct Query: Encodable {
                    let message = "Hello, Server!"
                }
                let response = try client.post(
                    path: "/",
                    object: Query(),
                    contentType: .formURLEncoded)
                expect(response.status == .ok)
                expect(response.string == "message=Hello,%20Client!")
            }
        )
    }
}
