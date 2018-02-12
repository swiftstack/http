import Test

@testable import HTTP

class CookiesMiddlewareTests: TestCase {
    func testMiddleware() {
        final class TestController: Controller, InjectService {
            static var middleware: [ControllerMiddleware.Type] {
                return [CookiesMiddleware.self]
            }

            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/first", to: first)
                router.route(get: "/second", to: second)
            }

            let context: Context

            init(_ context: Context) {
                self.context = context
            }

            func first() -> String {
                context.cookies["cookie-name"] = "cookie-value"
                return "ok"
            }

            func second() -> String? {
                return context.cookies["cookie-name"]
            }
        }

        do {
            try Services.shared.register(
                singleton: InMemoryCookiesStorage.self,
                as: CookiesStorage.self)

            let application = Application()
            try application.addController(TestController.self)

            let firstRequest = Request(url: "/first", method: .get)
            let firstResponse = application.handleRequest(firstRequest)
            assertEqual(firstResponse?.setCookie.count, 1)
            guard let setCookie = firstResponse?.setCookie.first else {
                return
            }
            assertEqual(setCookie.cookie.name, "swift-stack-cookies")
            assertFalse(setCookie.cookie.value.isEmpty)

            let secondRequest = Request(url: "/second", method: .get)
            var secondResponse = application.handleRequest(secondRequest)
            assertEqual(secondResponse?.status, .noContent)
            assertNil(secondResponse?.string)

            secondRequest.cookies.append(setCookie.cookie)
            secondResponse = application.handleRequest(secondRequest)
            assertEqual(secondResponse?.string, "cookie-value")

        } catch {
            fail(String(describing: error))
        }
    }
}
