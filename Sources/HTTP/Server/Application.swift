public class Application: RouterProtocol {
    public struct Route {
        public let methods: Router.MethodSet
        public let url: String
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

    public func registerRoute(
        methods: Router.MethodSet,
        url: String,
        middleware: [Middleware.Type],
        handler: @escaping RequestHandler
    ) {
        routes.append(Route(
            methods: methods,
            url: self.basePath + url,
            middleware: self.middleware + middleware,
            handler: handler
        ))
    }
}

extension RouterProtocol {
    public mutating func addApplication(_ application: Application) {
        for route in application.routes {
            self.route(
                methods: route.methods,
                url: route.url,
                middleware: route.middleware,
                handler: route.handler)
        }
    }
}
