import Test

@testable import HTTP

test("Middleware") {
    struct TestMiddleware: Middleware {
        public static func chain(
            with handler: @escaping RequestHandler
        ) -> RequestHandler {
            return { request in
                let response = try await handler(request)
                response.status = .ok
                response.headers["Custom-Header"] = "Middleware"
                return response
            }
        }
    }

    let router = Router()

    router.route(
        get: "/middleware",
        through: [TestMiddleware.self]
    ) {
        return Response(status: .internalServerError)
    }

    let request = Request(url: "/middleware", method: .get)
    let response = await router.handle(request)

    expect(response?.headers["Custom-Header"] == "Middleware")
}

test("MiddlewareOrder") {
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

    let router = Router()

    router.route(
        get: "/middleware",
        through: [FirstMiddleware.self, SecondMiddleware.self]
    ) {
        return Response(status: .ok)
    }

    let request = Request(url: "/middleware", method: .get)
    let response = await router.handle(request)

    expect(response?.headers["FirstMiddleware"] == "true")
    expect(response?.headers["SecondMiddleware"] == "true")
    expect(response?.headers["Middleware"] == "first")
}

await run()
