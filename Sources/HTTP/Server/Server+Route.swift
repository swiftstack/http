import JSON

// Convenience constructors

extension Server {
    // GET
    @_inlineable
    public func route(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // HEAD
    @_inlineable
    public func route(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // POST
    @_inlineable
    public func route(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // PUT
    @_inlineable
    public func route(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // DELETE
    @_inlineable
    public func route(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // OPTIONS
    @_inlineable
    public func route(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // ALL
    @_inlineable
    public func route(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }
}

extension Server {
    // GET
    @_inlineable
    public func route<Result: Encodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // HEAD
    @_inlineable
    public func route<Result: Encodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // POST
    @_inlineable
    public func route<Result: Encodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // PUT
    @_inlineable
    public func route<Result: Encodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // DELETE
    @_inlineable
    public func route<Result: Encodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // OPTIONS
    @_inlineable
    public func route<Result: Encodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // ALL
    @_inlineable
    public func route<Result: Encodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }
}
