import Log
import JSON
import KeyValueCodable

public typealias RequestHandler = (Request) throws -> Response

public struct Router {
    public enum Error: Swift.Error {
        case invalidModel
        case invalidUrlMask
        case invalidRequest
        case invalidResponse
        case invalidContentType
    }

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

    // MARK: Transform convenient router result into Response

    @_versioned
    @inline(__always)
    static func makeRespone<T: Encodable>(for object: T) throws -> Response {
        switch object {
        case let string as String: return Response(string: string)
        case is Void: return Response(status: .ok)
        default: return try Response(body: object)
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

    @_versioned
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

    // void -> response
    @_inlineable
    public mutating func route(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        let handler: RequestHandler = { _ in
            return try handler()
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // void -> encodable
    @_inlineable
    public mutating func route<Result: Encodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(methods: methods, url: url) {
            let result = try handler()
            return try Router.makeRespone(for: result)
        }
    }

    // request -> response
    @_inlineable
    public mutating func route(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // request -> encodable
    @_inlineable
    public mutating func route<Result: Encodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(methods: methods, url: url) { request in
            let result = try handler(request)
            return try Router.makeRespone(for: result)
        }
    }

    // MARK: Decoder

    @_versioned
    @inline(__always)
    static func decodeModel<T: Decodable>(
        _ type: T.Type,
        from request: Request
    ) throws -> T {
        switch request.method {
        case .get:
            let values = request.url.query?.values ?? [:]
            return try KeyValueDecoder().decode(type, from: values)

        case _ where request.rawBody != nil && request.contentType != nil:
            let body = request.rawBody!
            let contentType = request.contentType!

            switch contentType.mediaType {
            case .application(.json):
                return try JSONDecoder().decode(type, from: body)

            case .application(.urlFormEncoded):
                let values = try URL.Query(from: body).values
                return try KeyValueDecoder().decode(type, from: values)

            default:
                throw Error.invalidContentType
            }

        default:
            throw Error.invalidRequest
        }
    }

    // model -> response
    @_inlineable
    public mutating func route<Model: Decodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(url)

        let requestHandler: RequestHandler

        if urlMatcher.params.count > 0 {
            requestHandler = { request in
                let values = urlMatcher.match(from: request.url.path)
                let match = try keyValueDecoder.decode(Model.self, from: values)
                return try handler(match)
            }
        } else {
            requestHandler = { request in
                let model = try Router.decodeModel(Model.self, from: request)
                return try handler(model)
            }
        }

        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: requestHandler
        )
    }

    // model -> encodable
    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(methods: methods, url: url) { (model: Model) throws -> Response in
            let result = try handler(model)
            return try Router.makeRespone(for: result)
        }
    }

    // rquest, model -> response
    @_inlineable
    public mutating func route<Model: Decodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(url)

        let requestHandler: RequestHandler

        if urlMatcher.params.count > 0 {
            requestHandler = { request in
                let values = urlMatcher.match(from: request.url.path)
                let match = try keyValueDecoder.decode(Model.self, from: values)
                return try handler(request, match)
            }
        } else {
            requestHandler = { request in
                let model = try Router.decodeModel(Model.self, from: request)
                return try handler(request, model)
            }
        }

        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: requestHandler
        )
    }

    // rquest, model -> encodable
    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(methods: methods, url: url)
        { (request: Request, model: Model) throws -> Response in
            let result = try handler(request, model)
            return try Router.makeRespone(for: result)
        }
    }

    // url match, model -> result
    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(url)

        guard urlMatcher.params.count > 0 else {
            fatalError("invalid url mask, more than 0 arguments was expected")
        }

        let requestHandler: RequestHandler = { request in
            let values = urlMatcher.match(from: request.url.path)
            let match = try keyValueDecoder.decode(URLMatch.self, from: values)
            let model = try Router.decodeModel(Model.self, from: request)
            return try handler(match, model)
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: requestHandler
        )
    }

    // url match, model -> encodable
    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(methods: methods, url: url)
        { (match: URLMatch, model: Model) throws -> Response in
            let result = try handler(match, model)
            return try Router.makeRespone(for: result)
        }
    }

    // request, url match, model -> request
    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(url)

        guard urlMatcher.params.count > 0 else {
            fatalError("invalid url mask, more than 0 arguments was expected")
        }

        let handler: RequestHandler = { request in
            let values = urlMatcher.match(from: request.url.path)
            let match = try keyValueDecoder.decode(URLMatch.self, from: values)
            let model = try Router.decodeModel(Model.self, from: request)
            return try handler(request, match, model)
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // request, url match, model -> encodable
    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(methods: methods, url: url)
        { (request: Request, match: URLMatch, model: Model) throws -> Response
            in
            let result = try handler(request, match, model)
            return try Router.makeRespone(for: result)
        }
    }
}
