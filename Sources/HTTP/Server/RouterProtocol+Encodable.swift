// Convenience routes

extension RouterProtocol {
    // GET
    @_inlineable
    public func route<Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    // HEAD
    @_inlineable
    public func route<Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    // POST
    @_inlineable
    public func route<Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    // PUT
    @_inlineable
    public func route<Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    // DELETE
    @_inlineable
    public func route<Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    // OPTIONS
    @_inlineable
    public func route<Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    // ALL
    @_inlineable
    public func route<Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }
}
