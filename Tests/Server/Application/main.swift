import Test

@testable import HTTP

test.case("Application") {
    let application = Application()

    application.route(get: "/test") {
        return Response(string: "test ok")
    }

    let request = Request(url: "/test", method: .get)
    let response = try? await application.process(request)
    expect(response?.string == "test ok")
}

test.case("ApplicationBasePath") {
    let application = Application(basePath: "/v1")

    application.route(get: "/test") {
        return Response(string: "test ok")
    }
    let request = Request(url: "/v1/test", method: .get)
    let response = try? await application.process(request)
    expect(response?.string == "test ok")
}

test.case("ApplicationMiddleware") {
    struct FirstMiddleware: Middleware {
        public static func chain(
            with handler: @escaping RequestHandler
        ) -> RequestHandler {
            return { request in
                let response = try await handler(request)
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
                let response = try await handler(request)
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
    let firstResponse = try? await application.process(firstRequest)
    expect(firstResponse?.string == "first ok")
    expect(firstResponse?.headers["Middleware"] == "first")
    expect(firstResponse?.headers["FirstMiddleware"] == "true")

    let secondRequest = Request(url: "/first-second", method: .get)
    let secondResponse = try? await application.process(secondRequest)
    expect(secondResponse?.string == "first-second ok")
    expect(secondResponse?.headers["Middleware"] == "first")
    expect(secondResponse?.headers["FirstMiddleware"] == "true")
    expect(secondResponse?.headers["SecondMiddleware"] == "true")
}

test.run()
