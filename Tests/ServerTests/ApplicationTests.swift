import Test
import Stream

@testable import HTTP

extension Server {
    func process(_ request: Request) throws -> Response {
        let inputStreamTemp = OutputByteStream()
        try request.encode(to: inputStreamTemp)

        let inputStream = InputByteStream(inputStreamTemp.bytes)
        let outputStream = OutputByteStream()

        let byteStream = ByteStream(
            inputStream: inputStream,
            outputStream: outputStream)

        self.process(stream: byteStream)

        return try Response(from: InputByteStream(outputStream.bytes))
    }
}

class ApplicationTests: TestCase {
    func assertNoThrow(_ task: () throws -> Void) {
        do {
            try task()
        } catch {
            fail(String(describing: error))
        }
    }

    func testApplication() {
        assertNoThrow {
            var server = try Server(host: "127.0.0.1", port: 4301)

            var application = Application()

            application.route(get: "/test") {
                return Response(string: "test ok")
            }

            server.addApplication(application)

            let request = Request(method: .get, url: "/test")
            let response = try server.process(request)
            assertEqual(response.string, "test ok")
        }
    }

    func testApplicationBasePath() {
        assertNoThrow {
            var server = try Server(host: "127.0.0.1", port: 4302)

            var application = Application(basePath: "/v1")

            application.route(get: "/test") {
                return Response(string: "test ok")
            }

            server.addApplication(application)

            let request = Request(method: .get, url: "/v1/test")
            let response = try server.process(request)
            assertEqual(response.string, "test ok")
        }
    }

    func testApplicationMiddleware() {
        struct FirstMiddleware: Middleware {
            public static func createMiddleware(
                for handler: @escaping RequestHandler
            ) -> RequestHandler {
                return { request in
                    let response = try handler(request)
                    response.headers["Middleware"] = "first"
                    response.headers["FirstMiddleware"] = "true"
                    return response
                }
            }
        }

        struct SecondMiddleware: Middleware {
            public static func createMiddleware(
                for handler: @escaping RequestHandler
            ) -> RequestHandler {
                return { request in
                    let response = try handler(request)
                    response.headers["Middleware"] = "second"
                    response.headers["SecondMiddleware"] = "true"
                    return response
                }
            }
        }

        assertNoThrow {
            var server = try Server(host: "127.0.0.1", port: 4303)

            var application = Application(middleware: [FirstMiddleware.self])

            application.route(get: "/first") {
                return Response(string: "first ok")
            }

            application.route(
                get: "/first-second",
                middleware: [SecondMiddleware.self])
            {
                return Response(string: "first-second ok")
            }

            server.addApplication(application)

            let firstRequest = Request(method: .get, url: "/first")
            let firstResponse = try server.process(firstRequest)
            assertEqual(firstResponse.string, "first ok")
            assertEqual(firstResponse.headers["Middleware"], "first")
            assertEqual(firstResponse.headers["FirstMiddleware"], "true")

            let secondRequest = Request(method: .get, url: "/first-second")
            let secondResponse = try server.process(secondRequest)
            assertEqual(secondResponse.string, "first-second ok")
            assertEqual(secondResponse.headers["Middleware"], "first")
            assertEqual(secondResponse.headers["FirstMiddleware"], "true")
            assertEqual(secondResponse.headers["SecondMiddleware"], "true")
        }
    }
}
