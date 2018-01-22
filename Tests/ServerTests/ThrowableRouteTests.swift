import Test

@testable import HTTP

extension String: Swift.Error {}

func makeMistake() throws {
    throw "expected failure"
}

class ThrowableRouteTests: TestCase {
    class Server: RouterProtocol {
        let bufferSize: Int = 4096

        @_versioned
        var router = Router()

        public func registerRoute(
            path: String,
            methods: Router.MethodSet,
            middleware: [Middleware.Type],
            handler: @escaping RequestHandler
        ) {
            router.registerRoute(
                path: path,
                methods: methods,
                middleware: middleware,
                handler: handler)
        }

        public func findHandler(
            path: String,
            methods: Router.MethodSet
        ) -> RequestHandler? {
            return router.findHandler(path: path, methods: methods)
        }
    }

    func testGet() {
        let server = Server()

        server.route(get: "/") {
            try makeMistake()
            return Response(status: .ok)
        }

        let request = Request(url: "/", method: .get)
        let response = server.handleRequest(request)
        assertEqual(response?.status, .internalServerError)
    }

    func testHead() {
        let server = Server()

        server.route(head: "/") {
            try makeMistake()
            return Response(status: .ok)
        }

        let request = Request(url: "/", method: .head)
        let response = server.handleRequest(request)
        assertEqual(response?.status, .internalServerError)
    }

    func testPost() {
        let server = Server()

        server.route(post: "/") {
            try makeMistake()
            return Response(status: .ok)
        }

        let request = Request(url: "/", method: .post)
        let response = server.handleRequest(request)
        assertEqual(response?.status, .internalServerError)
    }

    func testPut() {
        let server = Server()

        server.route(put: "/") {
            try makeMistake()
            return Response(status: .ok)
        }

        let request = Request(url: "/", method: .put)
        let response = server.handleRequest(request)
        assertEqual(response?.status, .internalServerError)
    }

    func testDelete() {
        let server = Server()

        server.route(delete: "/") {
            try makeMistake()
            return Response(status: .ok)
        }

        let request = Request(url: "/", method: .delete)
        let response = server.handleRequest(request)
        assertEqual(response?.status, .internalServerError)
    }

    func testOptions() {
        let server = Server()

        server.route(options: "/") {
            try makeMistake()
            return Response(status: .ok)
        }

        let request = Request(url: "/", method: .options)
        let response = server.handleRequest(request)
        assertEqual(response?.status, .internalServerError)
    }
}
