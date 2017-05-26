import HTTP
import JSON
import Reflection

// Convenience constructors

extension Server {
    // GET
    public func route(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            method: .get, url: url, middleware: middleware, handler: handler)
    }

    public func route(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            method: .get, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .get, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .get, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .get, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        get url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .get, url: url, middleware: middleware, handler: handler)
    }

    // HEAD
    public func route(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            method: .head, url: url, middleware: middleware, handler: handler)
    }

    public func route(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            method: .head, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .head, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .head, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .head, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        head url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .head, url: url, middleware: middleware, handler: handler)
    }

    // POST
    public func route(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            method: .post, url: url, middleware: middleware, handler: handler)
    }

    public func route(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            method: .post, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .post, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .post, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .post, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        post url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .post, url: url, middleware: middleware, handler: handler)
    }

    // PUT
    public func route(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            method: .put, url: url, middleware: middleware, handler: handler)
    }

    public func route(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            method: .put, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .put, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .put, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .put, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        put url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .put, url: url, middleware: middleware, handler: handler)
    }

    // DELETE
    public func route(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            method: .delete, url: url, middleware: middleware, handler: handler)
    }

    public func route(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            method: .delete, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .delete, url: url, middleware: middleware, handler: handler)
    }

    public func route<A: Primitive>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .delete, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .delete, url: url, middleware: middleware, handler: handler)
    }

    public func route<A>(
        delete url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .delete, url: url, middleware: middleware, handler: handler)
    }

    // OPTIONS
    public func route(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping () throws -> Any
    ) {
        router.route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request) throws -> Any
    ) {
        router.route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A: Primitive>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A: Primitive>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (A) throws -> Any
    ) {
        router.route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }

    public func route<A>(
        options url: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (Request, A) throws -> Any
    ) {
        router.route(
            method: .options,
            url: url,
            middleware: middleware,
            handler: handler
        )
    }
}
