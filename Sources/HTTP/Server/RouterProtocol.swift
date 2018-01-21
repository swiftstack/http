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
        var handler: RequestHandler = handler
        for factory in middleware.reversed() {
            handler = factory.createMiddleware(for: handler)
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
        route(path: path, methods: methods) { request in
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
        route(path: path, methods: methods) { request in
            let result = try handler(request)
            return try Coder.makeRespone(for: request, encoding: result)
        }
    }
}

// MARK: Decoder

extension RouterProtocol {
    // MARK: model -> response
    @_inlineable
    public func route<Model: Decodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(path)

        let requestHandler: RequestHandler

        if urlMatcher.params.count > 0 {
            requestHandler = { request in
                let values = urlMatcher.match(from: request.url.path)
                let match = try keyValueDecoder.decode(Model.self, from: values)
                return try handler(match)
            }
        } else {
            requestHandler = { request in
                let model = try Coder.decodeModel(Model.self, from: request)
                return try handler(model)
            }
        }

        registerRoute(
            path: path,
            methods: methods,
            middleware: middleware,
            handler: requestHandler
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
        route(path: path, methods: methods)
        { (request: Request, model: Model) throws -> Response in
            let result = try handler(model)
            return try Coder.makeRespone(for: request, encoding: result)
        }
    }

    // MARK: rquest, model -> response
    @_inlineable
    public func route<Model: Decodable>(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(path)

        let requestHandler: RequestHandler

        if urlMatcher.params.count > 0 {
            requestHandler = { request in
                let values = urlMatcher.match(from: request.url.path)
                let match = try keyValueDecoder.decode(Model.self, from: values)
                return try handler(request, match)
            }
        } else {
            requestHandler = { request in
                let model = try Coder.decodeModel(Model.self, from: request)
                return try handler(request, model)
            }
        }

        registerRoute(
            path: path,
            methods: methods,
            middleware: middleware,
            handler: requestHandler
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
        route(path: path, methods: methods)
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
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(path)

        guard urlMatcher.params.count > 0 else {
            fatalError("invalid url mask, more than 0 arguments were expected")
        }

        let requestHandler: RequestHandler = { request in
            let values = urlMatcher.match(from: request.url.path)
            let match = try keyValueDecoder.decode(URLMatch.self, from: values)
            let model = try Coder.decodeModel(Model.self, from: request)
            return try handler(match, model)
        }
        registerRoute(
            path: path,
            methods: methods,
            middleware: middleware,
            handler: requestHandler
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
        route(path: path, methods: methods)
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
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(path)

        guard urlMatcher.params.count > 0 else {
            fatalError("invalid url mask, more than 0 arguments was expected")
        }

        let handler: RequestHandler = { request in
            let values = urlMatcher.match(from: request.url.path)
            let match = try keyValueDecoder.decode(URLMatch.self, from: values)
            let model = try Coder.decodeModel(Model.self, from: request)
            return try handler(request, match, model)
        }
        registerRoute(
            path: path,
            methods: methods,
            middleware: middleware,
            handler: handler
        )
    }

    // MARK: request, url match, model -> encodable
    @_inlineable
    public func route
    <
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(path: path, methods: methods)
        { (request: Request, match: URLMatch, model: Model) throws -> Response
            in
            let result = try handler(request, match, model)
            return try Coder.makeRespone(for: request, encoding: result)
        }
    }
}
