import Log
import JSON
import Reflection

public typealias RequestHandler = (Request) throws -> Response

struct Router {
    struct Route {
        let method: Request.Method
        let handler: RequestHandler
    }

    var routeMatcher = RouteMatcher<Route>()

    func handleRequest(_ request: Request) -> Response {
        let routes = routeMatcher.matches(route: request.url.path)
        guard let route = routes.first(where: { route in
            route.method == request.method
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
        method: Request.Method,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping RequestHandler
    ) {
        let handler = chainMiddlewares(middleware, with: handler)
        let route = Route(method: method, handler: handler)
        routeMatcher.add(route: url, payload: route)
    }

    // MARK: Simple routes

    // void
    public mutating func route(
        method: Request.Method,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        let handler: RequestHandler = { _ in
            try Router.parseAnyResponse(try handler())
        }
        registerRoute(
            method: method,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // request
    public mutating func route(
        method: Request.Method,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        let handler: RequestHandler = { request in
            return try Router.parseAnyResponse(try handler(request))
        }
        registerRoute(
            method: method,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // MARK: Reflection

    @inline(__always)
    func createReflectionWrapper(
        method: Request.Method,
        url: String,
        handler: @escaping (Request, [String : Any]) throws -> Any
    ) -> RequestHandler {
        let urlMatcher = URLParamMatcher(url)

        return { request in
            var values = urlMatcher.match(from: request.url.path)

            let queryValues: [String: Any]?

            if method == .get {
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
        method: Request.Method,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        let handler = createReflectionWrapper(method: method, url: url) {
            _, values in
            // TODO: handle single value properly
            guard let value = values.first?.value as? String,
                let param = Model(param: value) else {
                    return Response(status: .badRequest)
            }
            return try handler(param)
        }
        registerRoute(
            method: method,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // pass request + primitive type: String | Bool | Int | Double.
    public mutating func route<Model: Primitive>(
        method: Request.Method,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        let handler = createReflectionWrapper(method: method, url: url) {
            request, values in
            // TODO: handle single value properly
            guard let value = values.first?.value as? String,
                let param = Model(param: value) else {
                    return Response(status: .badRequest)
            }
            return try handler(request, param)
        }
        registerRoute(
            method: method,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // foreign struct
    public mutating func route<Model>(
        method: Request.Method,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        let handler = createReflectionWrapper(method: method, url: url) {
            _, values in
            guard let model = Blueprint(of: Model.self)
                .construct(using: values) else {
                    return Response(status: .badRequest)
            }
            return try handler(model)
        }
        registerRoute(
            method: method,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // reflection: request data + POD value type
    public mutating func route<Model>(
        method: Request.Method,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        let handler = createReflectionWrapper(method: method, url: url) {
            request, values in
            guard let model = Blueprint(of: Model.self)
                .construct(using: values) else {
                    return Response(status: .badRequest)
            }
            return try handler(request, model)
        }
        registerRoute(
            method: method,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }
}
