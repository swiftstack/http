// We want the same '.route' APIs for Server and Application
// but while Server registers it directly in the Router
// Application needs to store them until it get passed to the Server

public protocol RouterProtocol: class {
    func registerRoute(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type],
        handler: @escaping RequestHandler
    )

    func findHandler(
        path: String,
        methods: Router.MethodSet
    ) -> RequestHandler?
}

extension RouterProtocol {
    func chainMiddleware(
        _ middleware: [Middleware.Type],
        with handler: @escaping RequestHandler
    ) -> RequestHandler {
        var handler = handler
        for next in middleware.reversed() {
            handler = next.chain(with: handler)
        }
        return handler
    }
}

// MARK: Simple routes

extension RouterProtocol {
    // MARK: void -> response
    @_inlineable
    public func route(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        let handler: RequestHandler = { _ in
            return try handler()
        }
        registerRoute(
            path: path,
            methods: methods,
            middleware: middleware,
            handler: handler
        )
    }

    // MARK: request -> response
    @_inlineable
    public func route(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        registerRoute(
            path: path,
            methods: methods,
            middleware: middleware,
            handler: handler
        )
    }
}

extension RouterProtocol {
    // MARK: void -> encodable
    @_inlineable
    public func route<Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware) { request in
            let result = try handler()
            return try Coder.makeRespone(for: request, encoding: result)
        }
    }

    // MARK: request -> encodable
    @_inlineable
    public func route<Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware) { request in
            let result = try handler(request)
            return try Coder.makeRespone(for: request, encoding: result)
        }
    }
}

// MARK: Decoder

extension RouterProtocol {
    @_versioned
    @inline(__always)
    func makeHandler<Model: Decodable>(
        for path: String,
        wrapping handler: @escaping (Model) throws -> Response
    ) -> RequestHandler {
        return makeHandler(for: path) { (_: Request, model: Model) in
            try handler(model)
        }
    }

    @_versioned
    func makeHandler<Model: Decodable>(
        for path: String,
        wrapping handler: @escaping (Request, Model) throws -> Response
    ) -> RequestHandler {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(path)

        if urlMatcher.params.count > 0 {
            return { request in
                let values = urlMatcher.match(from: request.url.path)
                let match = try keyValueDecoder.decode(Model.self, from: values)
                return try handler(request, match)
            }
        } else {
            return { request in
                let model = try Coder.decodeModel(Model.self, from: request)
                return try handler(request, model)
            }
        }
    }

    @_versioned
    func makeHandler<URLMatch: Decodable, Model: Decodable>(
        for path: String,
        wrapping handler: @escaping (URLMatch, Model) throws -> Response
    ) -> RequestHandler {
        return makeHandler(for: path)
        { (_: Request, match: URLMatch, model: Model) in
            try handler(match, model)
        }
    }

    @_versioned
    func makeHandler<URLMatch: Decodable, Model: Decodable>(
        for path: String,
        wrapping handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) -> RequestHandler {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(path)

        guard urlMatcher.params.count > 0 else {
            fatalError("invalid url mask, more than 0 arguments were expected")
        }

        return { request in
            let values = urlMatcher.match(from: request.url.path)
            let match = try keyValueDecoder.decode(URLMatch.self, from: values)
            let model = try Coder.decodeModel(Model.self, from: request)
            return try handler(request, match, model)
        }
    }

    // MARK: model -> response
    @_inlineable
    public func route<Model: Decodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        let handler = makeHandler(for: path, wrapping: handler)
        registerRoute(
            path: path,
            methods: methods,
            middleware: middleware,
            handler: handler
        )
    }

    // MARK: model -> encodable
    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware)
        { (request: Request, model: Model) throws -> Response in
            let result = try handler(model)
            return try Coder.makeRespone(for: request, encoding: result)
        }
    }

    // MARK: request, model -> response
    @_inlineable
    public func route<Model: Decodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        let handler = makeHandler(for: path, wrapping: handler)
        registerRoute(
            path: path,
            methods: methods,
            middleware: middleware,
            handler: handler
        )
    }

    // MARK: rquest, model -> encodable
    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware)
        { (request: Request, model: Model) throws -> Response in
            let result = try handler(request, model)
            return try Coder.makeRespone(for: request, encoding: result)
        }
    }

    // MARK: url match, model -> result
    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        let handler = makeHandler(for: path, wrapping: handler)
        registerRoute(
            path: path,
            methods: methods,
            middleware: middleware,
            handler: handler
        )
    }

    // MARK: url match, model -> encodable
    @_inlineable
    public func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) throws -> Response
            in
            let result = try handler(match, model)
            return try Coder.makeRespone(for: request, encoding: result)
        }
    }

    // MARK: request, url match, model -> request
    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        let handler = makeHandler(for: path, wrapping: handler)
        registerRoute(
            path: path,
            methods: methods,
            middleware: middleware,
            handler: handler
        )
    }

    // MARK: request, url match, model -> encodable
    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) throws -> Response
            in
            let result = try handler(request, match, model)
            return try Coder.makeRespone(for: request, encoding: result)
        }
    }
}
