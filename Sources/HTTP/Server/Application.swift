public class Application: RouterProtocol {
    public struct Route {
        public let path: String
        public let methods: Router.MethodSet
        public let handler: RequestHandler
    }

    public let basePath: String
    public var middleware: [Middleware.Type]
    public var controllerMiddleware: [ControllerMiddleware.Type]

    public private(set) var routes = [Route]()

    public init(
        basePath: String = "",
        middleware: [Middleware.Type] = [],
        controllerMiddleware: [ControllerMiddleware.Type] = []
    ) {
        self.basePath = basePath
        self.middleware = middleware
        self.controllerMiddleware = controllerMiddleware
    }

    public func registerRoute(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type],
        handler: @escaping RequestHandler
    ) {
        let middleware = self.middleware + middleware
        let handler = chainMiddleware(middleware, with: handler)
        routes.append(Route(
            path: self.basePath + path,
            methods: methods,
            handler: handler
        ))
    }

    public func findHandler(
        path: String,
        methods: Router.MethodSet
    ) -> RequestHandler? {
        // NOTE: just for the tests
        let router = Router()
        router.addApplication(self)
        return router.findHandler(path: path, methods: methods)
    }
}

extension RouterProtocol {
    public func addApplication(_ application: Application) {
        for route in application.routes {
            self.registerRoute(
                path: route.path,
                methods: route.methods,
                middleware: [],
                handler: route.handler)
        }
    }
}
