/************************/
/** Convenience routes **/
/************************/

// MARK: -> Response

extension RouterProtocol {
    // GET
    @inlinable
    public func route(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Response
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Response
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    // HEAD
    @inlinable
    public func route(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Response
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Response
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    // POST
    @inlinable
    public func route(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Response
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Response
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    // PUT
    @inlinable
    public func route(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Response
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Response
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    // DELETE
    @inlinable
    public func route(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Response
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Response
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    // OPTIONS
    @inlinable
    public func route(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Response
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Response
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    // ALL
    @inlinable
    public func route(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping () throws -> Response
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request) throws -> Response
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (Request, URLMatch, Model) throws -> Response
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }
}

// MARK: -> Result

extension RouterProtocol {
    // GET
    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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
    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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
    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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
    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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
    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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
    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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
    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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

    @inlinable
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
