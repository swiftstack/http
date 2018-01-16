import Log

public typealias RequestHandler = (Request) throws -> Response

public struct Router: RouterProtocol {
    public struct MethodSet: OptionSet {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public static let get = MethodSet(rawValue: 1 << 0)
        public static let head = MethodSet(rawValue: 1 << 1)
        public static let post = MethodSet(rawValue: 1 << 2)
        public static let put = MethodSet(rawValue: 1 << 3)
        public static let delete = MethodSet(rawValue: 1 << 4)
        public static let options = MethodSet(rawValue: 1 << 5)

        public static let all: MethodSet = [
            .get, .head, .post, .put, .delete, .options
        ]
        
        fileprivate func contains(method: Request.Method) -> Bool {
            switch method {
            case .get: return contains(.get)
            case .head: return contains(.head)
            case .post: return contains(.post)
            case .put: return contains(.put)
            case .delete: return contains(.delete)
            case .options: return contains(.options)
            }
        }
    }

    struct Route {
        let methods: MethodSet
        let handler: RequestHandler
    }

    private var routeMatcher = RouteMatcher<Route>()

    func handleRequest(_ request: Request) -> Response {
        let routes = routeMatcher.matches(route: request.url.path)
        guard let route = routes.first(where: { route in
            route.methods.contains(method: request.method)
        }) else {
            return Response(status: .notFound)
        }

        do {
            return try route.handler(request)
        } catch {
            Log.debug(String(describing: error))
            return Response(status: .internalServerError)
        }
    }

    func chainMiddlewares(
        _ middleware: [Middleware.Type],
        with handler: @escaping RequestHandler
    ) -> RequestHandler {
        var handler: RequestHandler = handler
        for factory in middleware.reversed() {
            handler = factory.createMiddleware(for: handler)
        }
        return handler
    }

    mutating func registerRoute(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type],
        handler: @escaping RequestHandler
    ) {
        let handler = chainMiddlewares(middleware, with: handler)
        let route = Route(methods: methods, handler: handler)
        routeMatcher.add(route: url, payload: route)
    }
}
