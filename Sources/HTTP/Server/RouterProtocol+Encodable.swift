// Convenience constructors

extension RouterProtocol {
    // GET
    @_inlineable
    public mutating func route<Result: Encodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // HEAD
    @_inlineable
    public mutating func route<Result: Encodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // POST
    @_inlineable
    public mutating func route<Result: Encodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // PUT
    @_inlineable
    public mutating func route<Result: Encodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // DELETE
    @_inlineable
    public mutating func route<Result: Encodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // OPTIONS
    @_inlineable
    public mutating func route<Result: Encodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // ALL
    @_inlineable
    public mutating func route<Result: Encodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }
}
