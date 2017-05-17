import Reflection
import HTTP
import JSON

extension Server {

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
        with handler: @escaping Server.RequestHandler
    ) -> Server.RequestHandler {
        var handler: Server.RequestHandler = handler
        for factory in middleware.reversed() {
            handler = factory.createMiddleware(for: handler)
        }
        return handler
    }

    func registerRoute(
        method: Request.Method,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping Server.RequestHandler
    ) {
        let handler = chainMiddlewares(middleware, with: handler)
        let route = Route(method: method, handler: handler)
        routeMatcher.add(route: url, payload: route)
    }

    // MARK: Simple routes

    // void
    public func route(
        method: Request.Method,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Void) throws -> Any
    ) {
        let handler: Server.RequestHandler = { _ in
            try Server.parseAnyResponse(try handler())
        }
        registerRoute(
            method: method,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // request
    public func route(
        method: Request.Method,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        let handler: Server.RequestHandler = { request in
            return try Server.parseAnyResponse(try handler(request))
        }
        registerRoute(
            method: method,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // MARK: Reflection

    // primitive type: String | Bool | Int | Double.
    public func route<Model: Primitive>(
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
    public func route<Model: Primitive>(
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
    public func route<Model>(
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
    public func route<Model>(
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

    @inline(__always)
    func createReflectionWrapper(
        method: Request.Method,
        url: String,
        handler: @escaping (Request, [String : Any]) throws -> Any
    ) -> Server.RequestHandler {
        let urlMatcher = URLParamMatcher(url)

        return { request in
            var values = urlMatcher.match(from: request.url.path)

            let queryValues: [String: Any]?

            if method == .get {
                queryValues = request.url.query
            } else if let body = request.rawBody,
                let contentType = request.contentType {
                    switch contentType.mediaType {
                    case .application(.urlEncoded):
                        let query = String(cString: body + [0])
                        queryValues = URL.decode(urlEncoded: query)
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
            return try Server.parseAnyResponse(try handler(request, values))
        }
    }

    // Convenience constructors

    // GET
    public func route(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Void) throws -> Any
    ) {
        route(method: .get, url: url, middleware: middleware, handler: handler)
    }

    public func route(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        route(method: .get, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .get, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .get, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .get, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .get, url: url, middleware: middleware, handler: handler)
    }

    // HEAD
    public func route(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Void) throws -> Any
    ) {
        route(method: .head, url: url, middleware: middleware, handler: handler)
    }

    public func route(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        route(method: .head, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .head, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .head, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .head, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .head, url: url, middleware: middleware, handler: handler)
    }

    // POST
    public func route(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Void) throws -> Any
    ) {
        route(method: .post, url: url, middleware: middleware, handler: handler)
    }

    public func route(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        route(method: .post, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .post, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .post, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .post, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .post, url: url, middleware: middleware, handler: handler)
    }

    // PUT
    public func route(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Void) throws -> Any
    ) {
        route(method: .put, url: url, middleware: middleware, handler: handler)
    }

    public func route(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        route(method: .put, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .put, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .put, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .put, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .put, url: url, middleware: middleware, handler: handler)
    }

    // DELETE
    public func route(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Void) throws -> Any
    ) {
        route(
            method: .delete,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        route(
            method: .delete,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A: Primitive>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(
            method: .delete,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A: Primitive>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(
            method: .delete,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(
            method: .delete,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(
            method: .delete,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // OPTIONS
    public func route(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Void) throws -> Any
    ) {
        route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A: Primitive>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A: Primitive>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }
}
