public class Application: RouterProtocol {
    public struct Route {
        public let path: String
        public let methods: Router.MethodSet
        public let middleware: [Middleware.Type]
        public let handler: RequestHandler
    }

    public let basePath: String
    public let middleware: [Middleware.Type]

    public private(set) var routes = [Route]()

    public init(basePath: String = "", middleware: [Middleware.Type] = []) {
        self.basePath = basePath
        self.middleware = middleware
    }

    func registerRoute(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type],
        handler: @escaping RequestHandler
    ) {
        routes.append(Route(
            path: self.basePath + path,
            methods: methods,
            middleware: self.middleware + middleware,
            handler: handler
        ))
    }

    func findHandler(
        path: String,
        methods: Router.MethodSet
    ) -> RequestHandler? {
        guard let route = routes.first(where: { route in
            return route.path == path && route.methods.contains(methods)
        }) else {
            return nil
        }
        return route.handler
    }
}

extension RouterProtocol {
    public mutating func addApplication(_ application: Application) {
        for route in application.routes {
            self.route(
                path: route.path,
                methods: route.methods,
                middleware: route.middleware,
                handler: route.handler)
        }
    }
}
