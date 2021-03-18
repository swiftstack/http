import Test
import Event
@testable import HTTP

func setup(
    port: Int,
    serverCode: @escaping (Server) async throws -> Void,
    clientCode: @escaping (Client) async throws -> Void
) async {
    asyncTask {
        let server = try Server(host: "127.0.0.1", port: port)

        try await serverCode(server)

        try await server.start()

        await loop.terminate()
    }

    asyncTask {
        let client = Client(host: "127.0.0.1", port: port)
        try await client.connect()

        try await clientCode(client)

        await loop.terminate()
    }

    await loop.run()
}

test.case("Request") {
    await setup(
        port: 6000,
        serverCode: { server in
            server.route(get: "/") {
                return Response(status: .ok)
            }
        },
        clientCode: { client in
            let request = Request(url: "/", method: .get)
            let response = try await client.makeRequest(request)
            expect(response.status == .ok)
            expect(try await response.readBody() == [])
        }
    )
}

test.case("Get") {
    await setup(
        port: 6001,
        serverCode: { server in
            server.route(get: "/") {
                return Response(status: .ok)
            }
        },
        clientCode: { client in
            let response = try await client.get(path: "/")
            expect(response.status == .ok)
            expect(try await response.readBody() == [])
        }
    )
}

test.case("Head") {
    await setup(
        port: 6002,
        serverCode: { server in
            server.route(head: "/") {
                return Response(status: .ok)
            }
        },
        clientCode: { client in
            let response = try await client.head(path: "/")
            expect(response.status == .ok)
            expect(try await response.readBody() == [])
        }
    )
}

test.case("Post") {
    await setup(
        port: 6003,
        serverCode: { server in
            server.route(post: "/") {
                return Response(status: .ok)
            }
        },
        clientCode: { client in
            let response = try await client.post(path: "/")
            expect(response.status == .ok)
            expect(try await response.readBody() == [])
        }
    )
}

test.case("Put") {
    await setup(
        port: 6004,
        serverCode: { server in
            server.route(put: "/") {
                return Response(status: .ok)
            }
        },
        clientCode: { client in
            let response = try await client.put(path: "/")
            expect(response.status == .ok)
            expect(try await response.readBody() == [])
        }
    )
}

test.case("Delete") {
    await setup(
        port: 6005,
        serverCode: { server in
            server.route(delete: "/") {
                return Response(status: .ok)
            }
        },
        clientCode: { client in
            let response = try await client.delete(path: "/")
            expect(response.status == .ok)
            expect(try await response.readBody() == [])
        }
    )
}

test.case("Options") {
    await setup(
        port: 6006,
        serverCode: { server in
            server.route(options: "/") {
                return Response(status: .ok)
            }
        },
        clientCode: { client in
            let response = try await client.options(path: "/")
            expect(response.status == .ok)
            expect(try await response.readBody() == [])
        }
    )
}

test.case("All") {
    await setup(
        port: 6007,
        serverCode: { server in
            server.route(all: "/") {
                return Response(status: .ok)
            }
        },
        clientCode: { client in
            let getResponse = try await client.get(path: "/")
            expect(getResponse.status == .ok)

            let headResponse = try await client.head(path: "/")
            expect(headResponse.status == .ok)

            let postResponse = try await client.post(path: "/")
            expect(postResponse.status == .ok)

            let putResponse = try await client.put(path: "/")
            expect(putResponse.status == .ok)

            let deleteResponse = try await client.delete(path: "/")
            expect(deleteResponse.status == .ok)

            let optionsResponse = try await client.post(path: "/")
            expect(optionsResponse.status == .ok)
        }
    )
}

test.case("Json") {
    await setup(
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
            let response = try await client.post(path: "/", object: message)
            expect(response.status == .ok)
            let body = try await response.readBody()
            expect(body == ASCII("{\"message\":\"Hello, Client!\"}"))
        }
    )
}

test.case("FormEncoded") {
    await setup(
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
            let response = try await client.post(
                path: "/",
                object: Query(),
                contentType: .formURLEncoded)
            expect(response.status == .ok)
            let body = try await response.readBody()
            expect(body == ASCII("message=Hello,%20Client!"))
        }
    )
}

test.run()
