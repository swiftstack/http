import Test
import Event
@testable import HTTP

func setup(
    port: Int,
    serverCode: @escaping (Server) async throws -> Void,
    clientCode: @escaping (Client) async throws -> Void,
    file: StaticString = #file,
    line: UInt = #line
) async {
    Task {
        do {
            let server = try Server(host: "127.0.0.1", port: port)
            try await serverCode(server)
            try await server.start()
        } catch {
            fail(String(describing: error), file: file, line: line)
            await loop.terminate()
        }
    }

    Task {
        do {
            let client = Client(host: "127.0.0.1", port: port)
            try await Task.sleep(for: .milliseconds(1))
            try await client.connect()
            try await clientCode(client)
        } catch {
            fail(String(describing: error), file: file, line: line)
        }

        await loop.terminate()
    }

    await loop.run()
}

test("Request") {
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

test("Get") {
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

test("Head") {
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

test("Post") {
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

test("Put") {
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

test("Delete") {
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

test("Options") {
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

test("All") {
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

test("Json") {
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

test("FormEncoded") {
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

test("String") {
    await setup(
        port: 6010,
        serverCode: { server in
            struct Model: Codable {
                var message: String
            }
            server.route(post: "/") { (message: String) -> String in
                expect(message == "Hello, Server!")
                return "Hello, Client!"
            }
        },
        clientCode: { client in
            let message = "Hello, Server!"
            let request = try Request(url: "/", method: .post, body: message)
            let response = try await client.makeRequest(request)
            expect(response.status == .ok)
            let body = try await response.readBody()
            expect(body == ASCII("Hello, Client!"))
        }
    )
}

await run()
