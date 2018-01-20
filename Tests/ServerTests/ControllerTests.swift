import Test
import Stream

@testable import HTTP

protocol StringResult: Service {
    var string: String { get }
}

protocol ServiceOne: StringResult {}
protocol ServiceTwo: StringResult {}
protocol ServiceThree: StringResult {}
protocol ServiceFour: StringResult {}
protocol ServiceFive: StringResult {}
protocol ServiceSix: StringResult {}

final class TestServiceOne: ServiceOne {
    let string: String = "one"
}
final class TestServiceTwo: ServiceTwo {
    let string: String = "two"
}
final class TestServiceThree: ServiceThree {
    let string: String = "three"
}
final class TestServiceFour: ServiceFour {
    let string: String = "four"
}
final class TestServiceFive: ServiceFive {
    let string: String = "five"
}
final class TestServiceSix: ServiceSix {
    let string: String = "six"
}

class ControllerTests: TestCase {
    func testControllerInjectable() {
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

    func testControllerInjectService() {
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

    func testControllerInject2Services() {
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

    func testControllerInject3Services() {
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

    func testControllerInject4Services() {
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

    func testControllerInject5Services() {
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

    func testControllerInject6Services() {
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
}
