import Reflection
import HTTP
import JSON

extension Server {

    // MARK: Simple routes

    // void
    public func route(
        method: Request.Method,
        url: String,
        handler: @escaping (Void) throws -> Any
    ) {
        let route = Route(type: method, handler: { _ in try handler() })
        routeMatcher.add(route: url, payload: route)
    }

    // request
    public func route(
        method: Request.Method,
        url: String,
        handler: @escaping (Request) throws -> Any
    ) {
        let route = Route(type: method, handler: handler)
        routeMatcher.add(route: url, payload: route)
    }

    // MARK: Reflection

    // primitive type: Int | String | Double.
    public func route<Model: Primitive>(
        method: Request.Method,
        url: String,
        handler: @escaping (Model) throws -> Any
    ) {
        createRoute(method: method, url: url) { _, values in
            // TODO: handle single value properly
            guard let value = values.first?.value as? String,
                let param = Model(param: value) else {
                    return Response(status: .badRequest)
            }
            return try handler(param)
        }
    }

    // pass request + primitive type: Int | String | Double.
    public func route<Model: Primitive>(
        method: Request.Method,
        url: String,
        handler: @escaping (Request, Model) throws -> Any
    ) {
        createRoute(method: method, url: url) { request, values in
            // TODO: handle single value properly
            guard let value = values.first?.value as? String,
                let param = Model(param: value) else {
                    return Response(status: .badRequest)
            }
            return try handler(request, param)
        }
    }

    // foreign struct
    public func route<Model>(
        method: Request.Method,
        url: String,
        handler: @escaping (Model) throws -> Any
    ) {
        createRoute(method: method, url: url) { _, values in
            guard let model = Blueprint(of: Model.self)
                .construct(using: values) else {
                    return Response(status: .badRequest)
            }
            return try handler(model)
        }
    }

    // reflection: request data + POD value type
    public func route<Model>(
        method: Request.Method,
        url: String,
        handler: @escaping (Request, Model) throws -> Any
    ) {
        createRoute(method: method, url: url) { request, values in
            guard let model = Blueprint(of: Model.self)
                .construct(using: values) else {
                    return Response(status: .badRequest)
            }
            return try handler(request, model)
        }
    }

    @inline(__always)
    func createRoute(
        method: Request.Method,
        url: String,
        handler: @escaping (Request, [String : Any]) throws -> Any
    ) {
        let urlMatcher = URLParamMatcher(url)

        let wrapper: RequestHandler = { request in
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
            return try handler(request, values)
        }
        let route = Route(type: method, handler: wrapper)
        routeMatcher.add(route: url, payload: route)
    }

    // Convenience constructors

    // GET
    public func route(
        get url: String,
        handler: @escaping (Void) throws -> Any
    ) {
        route(method: .get, url: url, handler: handler)
    }

    public func route(
        get url: String,
        handler: @escaping (Request) throws -> Any
    ) {
        route(method: .get, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        get url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .get, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        get url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .get, url: url, handler: handler)
    }

    public func route<A>(
        get url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .get, url: url, handler: handler)
    }

    public func route<A>(
        get url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .get, url: url, handler: handler)
    }

    // HEAD
    public func route(
        head url: String,
        handler: @escaping (Void) throws -> Any
    ) {
        route(method: .head, url: url, handler: handler)
    }

    public func route(
        head url: String,
        handler: @escaping (Request) throws -> Any
    ) {
        route(method: .head, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        head url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .head, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        head url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .head, url: url, handler: handler)
    }

    public func route<A>(
        head url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .head, url: url, handler: handler)
    }

    public func route<A>(
        head url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .head, url: url, handler: handler)
    }

    // POST
    public func route(
        post url: String,
        handler: @escaping (Void) throws -> Any
    ) {
        route(method: .post, url: url, handler: handler)
    }

    public func route(
        post url: String,
        handler: @escaping (Request) throws -> Any
    ) {
        route(method: .post, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        post url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .post, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        post url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .post, url: url, handler: handler)
    }

    public func route<A>(
        post url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .post, url: url, handler: handler)
    }

    public func route<A>(
        post url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .post, url: url, handler: handler)
    }

    // PUT
    public func route(
        put url: String,
        handler: @escaping (Void) throws -> Any
    ) {
        route(method: .put, url: url, handler: handler)
    }

    public func route(
        put url: String,
        handler: @escaping (Request) throws -> Any
    ) {
        route(method: .put, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        put url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .put, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        put url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .put, url: url, handler: handler)
    }

    public func route<A>(
        put url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .put, url: url, handler: handler)
    }

    public func route<A>(
        put url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .put, url: url, handler: handler)
    }

    // DELETE
    public func route(
        delete url: String,
        handler: @escaping (Void) throws -> Any
    ) {
        route(method: .delete, url: url, handler: handler)
    }

    public func route(
        delete url: String,
        handler: @escaping (Request) throws -> Any
    ) {
        route(method: .delete, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        delete url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .delete, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        delete url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .delete, url: url, handler: handler)
    }

    public func route<A>(
        delete url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .delete, url: url, handler: handler)
    }

    public func route<A>(
        delete url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .delete, url: url, handler: handler)
    }

    // OPTIONS
    public func route(
        options url: String,
        handler: @escaping (Void) throws -> Any
    ) {
        route(method: .options, url: url, handler: handler)
    }

    public func route(
        options url: String,
        handler: @escaping (Request) throws -> Any
    ) {
        route(method: .options, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        options url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .options, url: url, handler: handler)
    }

    public func route<A: Primitive>(
        options url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .options, url: url, handler: handler)
    }

    public func route<A>(
        options url: String,
        handler: @escaping (A) throws -> Any
    ) {
        route(method: .options, url: url, handler: handler)
    }

    public func route<A>(
        options url: String,
        handler: @escaping (Request, A) throws -> Any
    ) {
        route(method: .options, url: url, handler: handler)
    }
}
