import Log
import JSON
import Reflection

public typealias RequestHandler = (Request) throws -> Response

struct Router {
    struct MethodSet: OptionSet {
        let rawValue: UInt8

        static let get = MethodSet(rawValue: 1 << 0)
        static let head = MethodSet(rawValue: 1 << 1)
        static let post = MethodSet(rawValue: 1 << 2)
        static let put = MethodSet(rawValue: 1 << 3)
        static let delete = MethodSet(rawValue: 1 << 4)
        static let options = MethodSet(rawValue: 1 << 5)

        static let all: MethodSet = [
            .get, .head, .post, .put, .delete, .options
        ]

        func contains(_ method: Request.Method) -> Bool {
            let member: MethodSet
            switch method {
            case .get: member = .get
            case .head: member = .head
            case .post: member = .post
            case .put: member = .put
            case .delete: member = .delete
            case .options: member = .options
            }
            return self.contains(member)
        }
    }

    struct Route {
        let methods: MethodSet
        let handler: RequestHandler
    }

    var routeMatcher = RouteMatcher<Route>()

    func handleRequest(_ request: Request) -> Response {
        let routes = routeMatcher.matches(route: request.url.path)
        guard let route = routes.first(where: { route in
            route.methods.contains(request.method)
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

    // MARK: Transform convenient router result into Response

    static func parseAnyResponse(_ object: Any) throws -> Response {
        switch object {
        case let response as Response: return response
        case let string as String: return Response(string: string)
        case is Void: return Response(status: .ok)
        default: return try Response(json: object)
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
        middleware: [Middleware.Type] = [],
        handler: @escaping RequestHandler
    ) {
        let handler = chainMiddlewares(middleware, with: handler)
        let route = Route(methods: methods, handler: handler)
        routeMatcher.add(route: url, payload: route)
    }

    // MARK: Simple routes

    // void
    public mutating func route(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        let handler: RequestHandler = { _ in
            try Router.parseAnyResponse(try handler())
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // request
    public mutating func route(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        let handler: RequestHandler = { request in
            return try Router.parseAnyResponse(try handler(request))
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // MARK: Reflection

    @inline(__always)
    func createReflectionWrapper(
        methods: MethodSet,
        url: String,
        handler: @escaping (Request, [String : Any]) throws -> Any
    ) -> RequestHandler {
        let urlMatcher = URLParamMatcher(url)

        return { request in
            var values = urlMatcher.match(from: request.url.path)

            let queryValues: [String: Any]?

            if request.method == .get {
                queryValues = request.url.query.values
            } else if let body = request.rawBody,
                let contentType = request.contentType {
                switch contentType.mediaType {
                case .application(.urlEncoded):
                    queryValues = try URL.Query(from: body).values
                case .application(.json):
                    queryValues = JSON.decode(body)
                default:
                    queryValues = nil
                }
            } else {
                queryValues = nil
            }

            if let queryValues = queryValues {
                for (key, value) in queryValues {
                    values[key] = value
                }
            }
            return try Router.parseAnyResponse(try handler(request, values))
        }
    }

    // primitive type: String | Bool | Int | Double.
    public mutating func route<Model: Primitive>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        let handler = createReflectionWrapper(methods: methods, url: url) {
            _, values in
            // TODO: handle single value properly
            guard let value = values.first?.value as? String,
                let param = Model(param: value) else {
                    return Response(status: .badRequest)
            }
            return try handler(param)
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // pass request + primitive type: String | Bool | Int | Double.
    public mutating func route<Model: Primitive>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        let handler = createReflectionWrapper(methods: methods, url: url) {
            request, values in
            // TODO: handle single value properly
            guard let value = values.first?.value as? String,
                let param = Model(param: value) else {
                    return Response(status: .badRequest)
            }
            return try handler(request, param)
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // foreign struct
    public mutating func route<Model>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        let handler = createReflectionWrapper(methods: methods, url: url) {
            _, values in
            guard let model = Blueprint(of: Model.self)
                .construct(using: values) else {
                    return Response(status: .badRequest)
            }
            return try handler(model)
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // reflection: request data + POD value type
    public mutating func route<Model>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        let handler = createReflectionWrapper(methods: methods, url: url) {
            request, values in
            guard let model = Blueprint(of: Model.self)
                .construct(using: values) else {
                    return Response(status: .badRequest)
            }
            return try handler(request, model)
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }
}
