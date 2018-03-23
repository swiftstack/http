public class Application: RouterProtocol {
    public struct Route {
        public let path: String
        public let methods: Router.MethodSet
        public let middleware: [Middleware.Type]
        public let handler: RequestHandler

        public init(
            path: String,
            methods: Router.MethodSet,
            middleware: [Middleware.Type],
            handler: @escaping RequestHandler)
        {
            self.path = path
            self.methods = methods
            self.middleware = middleware
            self.handler = handler
        }
    }

    public let basePath: String
    public var middleware: [Middleware.Type]

    public private(set) var routes = [Route]()

    public init(
        basePath: String = "",
        middleware: [Middleware.Type] = []
    ) {
        self.basePath = basePath
        self.middleware = middleware
    }

    public func registerRoute(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type],
        handler: @escaping RequestHandler
    ) {
        routes.append(Route(
            path: self.basePath + path,
            methods: methods,
            middleware: middleware,
            handler: handler))
    }

    // @testable
    func process(_ request: Request) throws -> Response {
        let router = Router()
        router.addApplication(self)
        return try router.process(request)
    }
}

extension RouterProtocol {
    public func addApplication(_ application: Application) {
        for route in application.routes {
            self.registerRoute(
                path: route.path,
                methods: route.methods,
                middleware: application.middleware + route.middleware,
                handler: route.handler)
        }
    }
}
