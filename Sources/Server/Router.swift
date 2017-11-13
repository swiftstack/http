import Log
import JSON
import KeyValueCodable

public typealias RequestHandler = (Request) throws -> Response

struct Router {
    enum Error: Swift.Error {
        case invalidModel
        case invalidUrlMask
        case invalidRequest
        case invalidResponse
        case invalidContentType
    }

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

    private var routeMatcher = RouteMatcher<Route>()

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
        case let encodable as Encodable: return try Response(json: encodable)
        default: throw Error.invalidResponse
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

    // MARK: Decoder

    @inline(__always)
    private static func decodeModel<T: Decodable>(
        _ type: T.Type,
        from request: Request
    ) throws -> T {
        switch request.method {
        case .get:
            let values = request.url.query.values
            return try KeyValueDecoder().decode(type, from: values)

        case _ where request.rawBody != nil && request.contentType != nil:
            let body = request.rawBody!
            let contentType = request.contentType!

            switch contentType.mediaType {
            case .application(.json):
                return try JSONDecoder().decode(type, from: body)

            case .application(.urlEncoded):
                let values = try URL.Query(from: body).values
                return try KeyValueDecoder().decode(type, from: values)

            default:
                throw Error.invalidContentType
            }

        default:
            throw Error.invalidRequest
        }
    }

    public mutating func route<Model: Decodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(url)

        let requestHandler: RequestHandler

        if urlMatcher.params.count > 0 {
            requestHandler = { request in
                let values = urlMatcher.match(from: request.url.path)
                let match = try keyValueDecoder.decode(Model.self, from: values)
                return try Router.parseAnyResponse(try handler(match))
            }
        } else {
            requestHandler = { request in
                let model = try Router.decodeModel(Model.self, from: request)
                return try Router.parseAnyResponse(try handler(model))
            }
        }

        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: requestHandler
        )
    }

    public mutating func route<Model: Decodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(url)

        let requestHandler: RequestHandler

        if urlMatcher.params.count > 0 {
            requestHandler = { request in
                let values = urlMatcher.match(from: request.url.path)
                let match = try keyValueDecoder.decode(Model.self, from: values)
                return try Router.parseAnyResponse(try handler(request, match))
            }
        } else {
            requestHandler = { request in
                let model = try Router.decodeModel(Model.self, from: request)
                return try Router.parseAnyResponse(try handler(request, model))
            }
        }

        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: requestHandler
        )
    }

    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Any
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
            return try Router.parseAnyResponse(
                try handler(match, model))
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: requestHandler
        )
    }

    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        methods: MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Any
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
            return try Router.parseAnyResponse(
                try handler(request, match, model))
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }
}
