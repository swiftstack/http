// MARK: Simple routes

extension RouterProtocol {
    // MARK: void -> response
    @inlinable
    public func route(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping () async throws -> Response
    ) {
        let handler: RequestHandler = { _ in
            return try await handler()
        }
        registerRoute(
            path: path,
            methods: methods,
            middleware: middleware,
            handler: handler
        )
    }

    // MARK: request -> response
    @inlinable
    public func route(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) async throws -> Response
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
    @inlinable
    public func route<Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping () async throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware) { request in
            let result = try await handler()
            return try await Coder.makeRespone(for: request, encoding: result)
        }
    }

    // MARK: request -> encodable
    @inlinable
    public func route<Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) async throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware) { request in
            let result = try await handler(request)
            return try await Coder.makeRespone(for: request, encoding: result)
        }
    }
}

// MARK: Decoder

extension RouterProtocol {
    @usableFromInline
    @inline(__always)
    func makeHandler<Model: Decodable>(
        for path: String,
        wrapping handler: @escaping (Model) async throws -> Response
    ) -> RequestHandler {
        return makeHandler(for: path) { (_: Request, model: Model) in
            try await handler(model)
        }
    }

    @usableFromInline
    func makeHandler<Model: Decodable>(
        for path: String,
        wrapping handler: @escaping (Request, Model) async throws -> Response
    ) -> RequestHandler {
        let urlMatcher = URLParamMatcher(path)

        if urlMatcher.params.count > 0 {
            return { request in
                let values = urlMatcher.match(from: request.url.path)
                let match = try Model(from: KeyValueDecoder(values))
                return try await handler(request, match)
            }
        } else {
            return { request in
                let model = try await Coder.decode(Model.self, from: request)
                return try await handler(request, model)
            }
        }
    }

    @usableFromInline
    func makeHandler<URLMatch: Decodable, Model: Decodable>(
        for path: String,
        wrapping handler: @escaping (URLMatch, Model) async throws -> Response
    ) -> RequestHandler {
        return makeHandler(for: path)
        { (_: Request, match: URLMatch, model: Model) in
            try await handler(match, model)
        }
    }

    @usableFromInline
    func makeHandler<URLMatch: Decodable, Model: Decodable>(
        for path: String,
        wrapping handler: @escaping (Request, URLMatch, Model) async throws -> Response
    ) -> RequestHandler {
        let urlMatcher = URLParamMatcher(path)

        guard urlMatcher.params.count > 0 else {
            fatalError("invalid url mask, more than 0 arguments were expected")
        }

        return { request in
            let values = urlMatcher.match(from: request.url.path)
            let match = try URLMatch(from: KeyValueDecoder(values))
            let model = try await Coder.decode(Model.self, from: request)
            return try await handler(request, match, model)
        }
    }

    // MARK: model -> response
    @inlinable
    public func route<Model: Decodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) async throws -> Response
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
    @inlinable
    public func route<Model: Decodable, Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) async throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware)
        { (request: Request, model: Model) async throws -> Response in
            let result = try await handler(model)
            return try await Coder.makeRespone(for: request, encoding: result)
        }
    }

    // MARK: request, model -> response
    @inlinable
    public func route<Model: Decodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) async throws -> Response
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
    @inlinable
    public func route<Model: Decodable, Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) async throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware)
        { (request: Request, model: Model) async throws -> Response in
            let result = try await handler(request, model)
            return try await Coder.makeRespone(for: request, encoding: result)
        }
    }

    // MARK: url match, model -> result
    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) async throws -> Response
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
    @inlinable
    public func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
        >(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) async throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) async throws -> Response
            in
            let result = try await handler(match, model)
            return try await Coder.makeRespone(for: request, encoding: result)
        }
    }

    // MARK: request, url match, model -> request
    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) async throws -> Response
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
    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) async throws -> Result
    ) {
        route(path: path, methods: methods, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) async throws -> Response
            in
            let result = try await handler(request, match, model)
            return try await Coder.makeRespone(for: request, encoding: result)
        }
    }
}
