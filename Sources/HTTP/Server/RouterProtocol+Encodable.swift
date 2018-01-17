// Convenience constructors

extension RouterProtocol {
    // GET
    @_inlineable
    public mutating func route<Result: Encodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    // HEAD
    @_inlineable
    public mutating func route<Result: Encodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    // POST
    @_inlineable
    public mutating func route<Result: Encodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    // PUT
    @_inlineable
    public mutating func route<Result: Encodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    // DELETE
    @_inlineable
    public mutating func route<Result: Encodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    // OPTIONS
    @_inlineable
    public mutating func route<Result: Encodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    // ALL
    @_inlineable
    public mutating func route<Result: Encodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Result: Encodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<Model: Decodable, Result: Encodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public mutating func route<
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }
}
