// We want the same '.route' APIs for Server and Application
// but while Server registers it directly in the Router
// Application needs to store them until it get passed to the Server

protocol RouterProtocol {
    mutating func registerRoute(
        methods: Router.MethodSet,
        url: String,
        middleware: [Middleware.Type],
        handler: @escaping RequestHandler
    )
}

// MARK: Simple routes

extension RouterProtocol {
    // MARK: void -> response
    @_inlineable
    public mutating func route(
        methods: Router.MethodSet,
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

    // MARK: request -> response
    @_inlineable
    public mutating func route(
        methods: Router.MethodSet,
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
}

extension RouterProtocol {
    // MARK: void -> encodable
    @_inlineable
    public mutating func route<Result: Encodable>(
        methods: Router.MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(methods: methods, url: url) {
            let result = try handler()
            return try Coder.makeRespone(for: result)
        }
    }

    // MARK: request -> encodable
    @_inlineable
    public mutating func route<Result: Encodable>(
        methods: Router.MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(methods: methods, url: url) { request in
            let result = try handler(request)
            return try Coder.makeRespone(for: result)
        }
    }
}

// MARK: Decoder

extension RouterProtocol {
    // MARK: model -> response
    @_inlineable
    public mutating func route<Model: Decodable>(
        methods: Router.MethodSet,
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
                let model = try Coder.decodeModel(Model.self, from: request)
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

    // MARK: model -> encodable
    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        methods: Router.MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(methods: methods, url: url) { (model: Model) throws -> Response in
            let result = try handler(model)
            return try Coder.makeRespone(for: result)
        }
    }

    // MARK: rquest, model -> response
    @_inlineable
    public mutating func route<Model: Decodable>(
        methods: Router.MethodSet,
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
                let model = try Coder.decodeModel(Model.self, from: request)
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

    // MARK: rquest, model -> encodable
    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        methods: Router.MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(methods: methods, url: url)
        { (request: Request, model: Model) throws -> Response in
            let result = try handler(request, model)
            return try Coder.makeRespone(for: result)
        }
    }

    // MARK: url match, model -> result
    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        methods: Router.MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(url)

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
            methods: methods,
            url: url,
            middleware: middleware,
            handler: requestHandler
        )
    }

    // MARK: url match, model -> encodable
    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        methods: Router.MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(methods: methods, url: url)
        { (match: URLMatch, model: Model) throws -> Response in
            let result = try handler(match, model)
            return try Coder.makeRespone(for: result)
        }
    }

    // MARK: request, url match, model -> request
    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        methods: Router.MethodSet,
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
            let model = try Coder.decodeModel(Model.self, from: request)
            return try handler(request, match, model)
        }
        registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    // MARK: request, url match, model -> encodable
    @_inlineable
    public mutating func route
    <
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        methods: Router.MethodSet,
        url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(methods: methods, url: url)
        { (request: Request, match: URLMatch, model: Model) throws -> Response
            in
            let result = try handler(request, match, model)
            return try Coder.makeRespone(for: result)
        }
    }
}
