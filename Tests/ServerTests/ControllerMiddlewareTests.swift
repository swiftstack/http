import Test

@testable import HTTP

class ControllerMiddlewareTests: TestCase {
    func testMiddleware() {
        struct TestControllerMiddleware: ControllerMiddleware {
            public static func chain(
                with middleware: @escaping (Context) throws -> Void
            ) -> (Context) throws -> Void {
                return { context in
                    try middleware(context)
                    context.response.string = "success"
                    context.response.headers["Custom-Header"] = "Middleware"
                }
            }
        }

        final class TestController: Controller, InjectService {
            static var middleware: [ControllerMiddleware.Type] {
                return [TestControllerMiddleware.self]
            }

            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/middleware", to: handler)
            }

            let context: Context

            init(_ context: Context) {
                self.context = context
            }

            func handler() -> String {
                context.response.headers["Controller"] = "OK"
                return "error"
            }
        }

        do {
            let application = Application()
            try application.addController(TestController.self)

            let request = Request(url: "/middleware", method: .get)
            let response = application.handleRequest(request)

            assertEqual(response?.headers["Custom-Header"], "Middleware")
        } catch {
            fail(String(describing: error))
        }
    }

    func testMiddlewareOrder() {
        struct FirstMiddleware: ControllerMiddleware {
            public static func chain(
                with middleware: @escaping (Context) throws -> Void
            ) -> (Context) throws -> Void {
                return { context in
                    try middleware(context)
                    context.response.headers["Middleware"] = "first"
                    context.response.headers["FirstMiddleware"] = "true"
                }
            }
        }

        struct SecondMiddleware: ControllerMiddleware {
            public static func chain(
                with middleware: @escaping (Context) throws -> Void
            ) -> (Context) throws -> Void {
                return { context in
                    try middleware(context)
                    context.response.headers["Middleware"] = "second"
                    context.response.headers["SecondMiddleware"] = "true"
                }
            }
        }

        final class TestController: Controller, InjectService {
            static var middleware: [ControllerMiddleware.Type] {
                return [FirstMiddleware.self, SecondMiddleware.self]
            }

            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/middleware", to: handler)
            }

            let context: Context

            init(_ context: Context) {
                self.context = context
            }

            func handler() -> String {
                context.response.headers["Controller"] = "OK"
                return "error"
            }
        }

        do {
            let application = Application()
            try application.addController(TestController.self)

            let request = Request(url: "/middleware", method: .get)
            let response = application.handleRequest(request)

            assertEqual(response?.headers["FirstMiddleware"], "true")
            assertEqual(response?.headers["SecondMiddleware"], "true")
            assertEqual(response?.headers["Middleware"], "first")
        } catch {
            fail(String(describing: error))
        }
    }
}
