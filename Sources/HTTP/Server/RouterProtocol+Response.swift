// Convenience constructors

extension RouterProtocol {
    // GET
    @_inlineable
    public mutating func route(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // HEAD
    @_inlineable
    public mutating func route(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // POST
    @_inlineable
    public mutating func route(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // PUT
    @_inlineable
    public mutating func route(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // DELETE
    @_inlineable
    public mutating func route(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // OPTIONS
    @_inlineable
    public mutating func route(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // ALL
    @_inlineable
    public mutating func route(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Response
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Response
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Response
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<URLMatch: Decodable, Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }
}
