import Test
import Stream

@testable import HTTP

class MiddlewareTests: TestCase {
    func testMiddleware() {
        struct TestMiddleware: Middleware {
            public static func createMiddleware(
                for handler: @escaping RequestHandler
            ) -> RequestHandler {
                return { request in
                    let response = try handler(request)
                    response.status = .ok
                    response.headers["Custom-Header"] = "Middleware"
                    return response
                }
            }
        }

        let router = Router()

        router.route(
            get: "/middleware",
            middleware: [TestMiddleware.self]
        ) {
            return Response(status: .internalServerError)
        }

        let request = Request(url: "/middleware", method: .get)
        let response = try? router.handleRequest(request)

        assertEqual(response?.headers["Custom-Header"], "Middleware")
    }

    func testMiddlewareOrder() {
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

        let router = Router()

        router.route(
            get: "/middleware",
            middleware: [FirstMiddleware.self, SecondMiddleware.self]
        ) {
            return Response(status: .ok)
        }

        let request = Request(url: "/middleware", method: .get)
        let response = try? router.handleRequest(request)

        assertEqual(response?.headers["FirstMiddleware"], "true")
        assertEqual(response?.headers["SecondMiddleware"], "true")
        assertEqual(response?.headers["Middleware"], "first")
    }
}
