import Test

@testable import HTTP

class ApplicationTests: TestCase {
    func testApplication() {
        let application = Application()

        application.route(get: "/test") {
            return Response(string: "test ok")
        }

        let request = Request(url: "/test", method: .get)
        let response = try? application.process(request)
        assertEqual(response?.string, "test ok")
    }

    func testApplicationBasePath() {
        let application = Application(basePath: "/v1")

        application.route(get: "/test") {
            return Response(string: "test ok")
        }
        let request = Request(url: "/v1/test", method: .get)
        let response = try? application.process(request)
        assertEqual(response?.string, "test ok")
    }

    func testApplicationMiddleware() {
        struct FirstMiddleware: Middleware {
            public static func chain(
                with handler: @escaping RequestHandler
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
            public static func chain(
                with handler: @escaping RequestHandler
            ) -> RequestHandler {
                return { request in
                    let response = try handler(request)
                    response.headers["Middleware"] = "second"
                    response.headers["SecondMiddleware"] = "true"
                    return response
                }
            }
        }

        let application = Application(middleware: [FirstMiddleware.self])

        application.route(get: "/first") {
            return Response(string: "first ok")
        }

        application.route(
            get: "/first-second",
            through: [SecondMiddleware.self])
        {
            return Response(string: "first-second ok")
        }
        let firstRequest = Request(url: "/first", method: .get)
        let firstResponse = try? application.process(firstRequest)
        assertEqual(firstResponse?.string, "first ok")
        assertEqual(firstResponse?.headers["Middleware"], "first")
        assertEqual(firstResponse?.headers["FirstMiddleware"], "true")

        let secondRequest = Request(url: "/first-second", method: .get)
        let secondResponse = try? application.process(secondRequest)
        assertEqual(secondResponse?.string, "first-second ok")
        assertEqual(secondResponse?.headers["Middleware"], "first")
        assertEqual(secondResponse?.headers["FirstMiddleware"], "true")
        assertEqual(secondResponse?.headers["SecondMiddleware"], "true")
    }
}
