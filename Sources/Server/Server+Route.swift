import HTTP
import JSON

// Convenience constructors

extension Server {
    // GET
    public func route(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.get],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // HEAD
    public func route(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.head],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // POST
    public func route(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.post],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // PUT
    public func route(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.put],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // DELETE
    public func route(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.delete],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // OPTIONS
    public func route(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Any
        ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.options],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    // ALL
    public func route(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Model) throws -> Any
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch) throws -> Any
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, Model) throws -> Any
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: URLDecodable, Model: Decodable>(
        all url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, URLMatch, Model) throws -> Any
    ) {
        router.route(
            methods: [.all],
            url: url,
            middleware: middleware,
            handler: handler)
    }
}
