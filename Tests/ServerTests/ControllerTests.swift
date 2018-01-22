import Test

@testable import HTTP

protocol StringResult: Service {
    var string: String { get }
}

extension StringResult {
    var string: String {
        // one two three four five six
        return "\(Self.self)".dropFirst("TestService".count).lowercased()
    }
}

protocol ServiceOne: StringResult {}
protocol ServiceTwo: StringResult {}
protocol ServiceThree: StringResult {}
protocol ServiceFour: StringResult {}
protocol ServiceFive: StringResult {}
protocol ServiceSix: StringResult {}

final class TestServiceOne: ServiceOne {}
final class TestServiceTwo: ServiceTwo {}
final class TestServiceThree: ServiceThree {}
final class TestServiceFour: ServiceFour {}
final class TestServiceFive: ServiceFive {}
final class TestServiceSix: ServiceSix {}

class ControllerTests: TestCase {
    func testInjectable() {
        final class TestController: Controller, Inject {
            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/", to: fetch)
            }

            func fetch() -> String {
                return "fetch ok"
            }
        }

        do {
            let application = Application()
            try application.addController(TestController.self)

            let request = Request(url: "/", method: .get)
            let response = application.handleRequest(request)
            assertEqual(response?.string, "fetch ok")

        } catch {
            fail(String(describing: error))
        }
    }

    func testInjectService() {
        final class TestController: Controller, InjectService {
            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/", to: fetch)
            }

            let serviceOne: ServiceOne

            init(_ serviceOne: ServiceOne) {
                self.serviceOne = serviceOne
            }

            func fetch() -> String {
                return serviceOne.string
            }
        }

        do {
            let application = Application()

            try Services.shared.register(
                transient: TestServiceOne.self,
                as: ServiceOne.self)

            try application.addController(TestController.self)

            let request = Request(url: "/", method: .get)
            let response = application.handleRequest(request)
            assertEqual(response?.string, "one")

        } catch {
            fail(String(describing: error))
        }
    }

    func testInject2Services() {
        final class TestController: Controller, Inject2Services {
            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/", to: fetch)
            }

            let serviceOne: ServiceOne
            let serviceTwo: ServiceTwo

            init(_ serviceOne: ServiceOne, _ serviceTwo: ServiceTwo) {
                self.serviceOne = serviceOne
                self.serviceTwo = serviceTwo
            }

            func fetch() -> String {
                return [
                    serviceOne.string,
                    serviceTwo.string
                ].joined(separator: " ")
            }
        }

        do {
            let application = Application()

            try Services.shared.register(
                transient: TestServiceOne.self,
                as: ServiceOne.self)
            try Services.shared.register(
                transient: TestServiceTwo.self,
                as: ServiceTwo.self)

            try application.addController(TestController.self)

            let request = Request(url: "/", method: .get)
            let response = application.handleRequest(request)
            assertEqual(response?.string, "one two")

        } catch {
            fail(String(describing: error))
        }
    }

    func testInject3Services() {
        final class TestController: Controller, Inject3Services {
            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/", to: fetch)
            }

            let serviceOne: ServiceOne
            let serviceTwo: ServiceTwo
            let serviceThree: ServiceThree

            init(
                _ serviceOne: ServiceOne,
                _ serviceTwo: ServiceTwo,
                _ serviceThree: ServiceThree
            ) {
                self.serviceOne = serviceOne
                self.serviceTwo = serviceTwo
                self.serviceThree = serviceThree
            }

            func fetch() -> String {
                return [
                    serviceOne.string,
                    serviceTwo.string,
                    serviceThree.string
                ].joined(separator: " ")
            }
        }

        do {
            let application = Application()

            try Services.shared.register(
                transient: TestServiceOne.self,
                as: ServiceOne.self)
            try Services.shared.register(
                transient: TestServiceTwo.self,
                as: ServiceTwo.self)
            try Services.shared.register(
                transient: TestServiceThree.self,
                as: ServiceThree.self)

            try application.addController(TestController.self)

            let request = Request(url: "/", method: .get)
            let response = application.handleRequest(request)
            assertEqual(response?.string, "one two three")

        } catch {
            fail(String(describing: error))
        }
    }

    func testInject4Services() {
        final class TestController: Controller, Inject4Services {
            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/", to: fetch)
            }

            let serviceOne: ServiceOne
            let serviceTwo: ServiceTwo
            let serviceThree: ServiceThree
            let serviceFour: ServiceFour

            init(
                _ serviceOne: ServiceOne,
                _ serviceTwo: ServiceTwo,
                _ serviceThree: ServiceThree,
                _ serviceFour: ServiceFour
            ) {
                self.serviceOne = serviceOne
                self.serviceTwo = serviceTwo
                self.serviceThree = serviceThree
                self.serviceFour = serviceFour
            }

            func fetch() -> String {
                return [
                    serviceOne.string,
                    serviceTwo.string,
                    serviceThree.string,
                    serviceFour.string,
                ].joined(separator: " ")
            }
        }

        do {
            let application = Application()

            try Services.shared.register(
                transient: TestServiceOne.self,
                as: ServiceOne.self)
            try Services.shared.register(
                transient: TestServiceTwo.self,
                as: ServiceTwo.self)
            try Services.shared.register(
                transient: TestServiceThree.self,
                as: ServiceThree.self)
            try Services.shared.register(
                transient: TestServiceFour.self,
                as: ServiceFour.self)

            try application.addController(TestController.self)

            let request = Request(url: "/", method: .get)
            let response = application.handleRequest(request)
            assertEqual(response?.string, "one two three four")

        } catch {
            fail(String(describing: error))
        }
    }

    func testInject5Services() {
        final class TestController: Controller, Inject5Services {
            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/", to: fetch)
            }

            let serviceOne: ServiceOne
            let serviceTwo: ServiceTwo
            let serviceThree: ServiceThree
            let serviceFour: ServiceFour
            let serviceFive: ServiceFive

            init(
                _ serviceOne: ServiceOne,
                _ serviceTwo: ServiceTwo,
                _ serviceThree: ServiceThree,
                _ serviceFour: ServiceFour,
                _ serviceFive: ServiceFive
            ) {
                self.serviceOne = serviceOne
                self.serviceTwo = serviceTwo
                self.serviceThree = serviceThree
                self.serviceFour = serviceFour
                self.serviceFive = serviceFive
            }

            func fetch() -> String {
                return [
                    serviceOne.string,
                    serviceTwo.string,
                    serviceThree.string,
                    serviceFour.string,
                    serviceFive.string
                ].joined(separator: " ")
            }
        }

        do {
            let application = Application()

            try Services.shared.register(
                transient: TestServiceOne.self,
                as: ServiceOne.self)
            try Services.shared.register(
                transient: TestServiceTwo.self,
                as: ServiceTwo.self)
            try Services.shared.register(
                transient: TestServiceThree.self,
                as: ServiceThree.self)
            try Services.shared.register(
                transient: TestServiceFour.self,
                as: ServiceFour.self)
            try Services.shared.register(
                transient: TestServiceFive.self,
                as: ServiceFive.self)

            try application.addController(TestController.self)

            let request = Request(url: "/", method: .get)
            let response = application.handleRequest(request)
            assertEqual(response?.string, "one two three four five")

        } catch {
            fail(String(describing: error))
        }
    }

    func testInject6Services() {
        final class TestController: Controller, Inject6Services {
            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/", to: fetch)
            }

            let serviceOne: ServiceOne
            let serviceTwo: ServiceTwo
            let serviceThree: ServiceThree
            let serviceFour: ServiceFour
            let serviceFive: ServiceFive
            let serviceSix: ServiceSix

            init(
                _ serviceOne: ServiceOne,
                _ serviceTwo: ServiceTwo,
                _ serviceThree: ServiceThree,
                _ serviceFour: ServiceFour,
                _ serviceFive: ServiceFive,
                _ serviceSix: ServiceSix
            ) {
                self.serviceOne = serviceOne
                self.serviceTwo = serviceTwo
                self.serviceThree = serviceThree
                self.serviceFour = serviceFour
                self.serviceFive = serviceFive
                self.serviceSix = serviceSix
            }

            func fetch() -> String {
                return [
                    serviceOne.string,
                    serviceTwo.string,
                    serviceThree.string,
                    serviceFour.string,
                    serviceFive.string,
                    serviceSix.string
                ].joined(separator: " ")
            }
        }

        do {
            let application = Application()

            try Services.shared.register(
                transient: TestServiceOne.self,
                as: ServiceOne.self)
            try Services.shared.register(
                transient: TestServiceTwo.self,
                as: ServiceTwo.self)
            try Services.shared.register(
                transient: TestServiceThree.self,
                as: ServiceThree.self)
            try Services.shared.register(
                transient: TestServiceFour.self,
                as: ServiceFour.self)
            try Services.shared.register(
                transient: TestServiceFive.self,
                as: ServiceFive.self)
            try Services.shared.register(
                transient: TestServiceSix.self,
                as: ServiceSix.self)

            try application.addController(TestController.self)

            let request = Request(url: "/", method: .get)
            let response = application.handleRequest(request)
            assertEqual(response?.string, "one two three four five six")

        } catch {
            fail(String(describing: error))
        }
    }

    func testInjectContext() {
        final class TestController: Controller, InjectService {
            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/", to: handler)
            }

            let context: Context

            init(_ context: Context) {
                self.context = context
            }

            func handler() -> String {
                return context.request.headers["test context"] ?? "error"
            }
        }

        do {
            let application = Application()
            try application.addController(TestController.self)

            let request = Request(url: "/", method: .get)
            request.headers["test context"] = "test context ok"

            let response = application.handleRequest(request)
            assertEqual(response?.string, "test context ok")

        } catch {
            fail(String(describing: error))
        }
    }

    func testInjectContextService() {
        final class TestController: Controller, Inject2Services {
            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/", to: handler)
            }

            let context: Context
            let serviceOne: ServiceOne

            init(_ context: Context, _ serviceOne: ServiceOne) {
                self.context = context
                self.serviceOne = serviceOne
            }

            func handler() -> String {
                let header = context.request.headers["test context"] ?? "error"
                return [header, serviceOne.string].joined(separator: " ")
            }
        }

        do {
            let application = Application()

            try Services.shared.register(
                transient: TestServiceOne.self,
                as: ServiceOne.self)

            try application.addController(TestController.self)

            let request = Request(url: "/", method: .get)
            request.headers["test context"] = "test context ok"

            let response = application.handleRequest(request)
            assertEqual(response?.string, "test context ok one")

        } catch {
            fail(String(describing: error))
        }
    }

    func testContextResponse() {
        final class TestController: Controller, InjectService {
            static func setup(router: ControllerRouter<TestController>) throws {
                router.route(get: "/", to: handler)
            }

            let context: Context

            init(_ context: Context) {
                self.context = context
            }

            func handler() -> String {
                context.response.headers["controller"] = "ok"
                return "ok"
            }
        }

        do {
            let application = Application()
            try application.addController(TestController.self)

            let request = Request(url: "/", method: .get)
            request.headers["test context"] = "test context ok"

            let response = application.handleRequest(request)
            assertEqual(response?.headers["controller"], "ok")

        } catch {
            fail(String(describing: error))
        }
    }
}
