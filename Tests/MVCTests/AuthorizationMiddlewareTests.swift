import Test

@testable import HTTP

class AuthorizationMiddlewareTests: TestCase {
    func testMiddleware() {
        struct User: UserProtocol {
            let name: String
            let claims: [String]
        }

        struct TestAuthorization: AuthorizationProtocol, Inject {
            func authenticate(context: Context) throws {
                context.user = User(name: "user", claims: [])
            }

            func authorizationFailed(context: Context) {
                context.response = Response(status: .unauthorized)
            }
        }

        final class TestController: Controller, InjectService {
            static var middleware: [ControllerMiddleware.Type] {
                return [AuthorizationMiddleware.self]
            }

            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/user", authorizing: .user("user"), to: user)
                router.route(get: "/admin", authorizing: .user("admin"), to: admin)
            }

            let context: Context

            init(_ context: Context) {
                self.context = context
            }

            func user() -> String {
                return context.user?.name ?? "error"
            }

            func admin() -> String {
                return context.user?.name ?? "error"
            }
        }

        do {
            try Services.shared.register(
                transient: TestAuthorization.self,
                as: AuthorizationProtocol.self)

            let application = Application()
            try application.addController(TestController.self)

            let userRequest = Request(url: "/user", method: .get)
            let userResponse = application.handleRequest(userRequest)
            assertEqual(userResponse?.status, .ok)
            assertEqual(userResponse?.string, "user")

            let adminRequest = Request(url: "/admin", method: .get)
            let adminResponse = application.handleRequest(adminRequest)
            assertEqual(adminResponse?.status, .unauthorized)
            assertEqual(adminResponse?.string, nil)
        } catch {
            fail(String(describing: error))
        }
    }
}
