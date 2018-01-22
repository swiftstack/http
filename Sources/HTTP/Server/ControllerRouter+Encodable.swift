// Convenience routes

extension ControllerRouter {

    // MARK: GET

    public func route<Result: Encodable>(
        get path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            middleware: middleware,
            handler: handler)
    }

    // MARK: HEAD

    public func route<Result: Encodable>(
        head path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            middleware: middleware,
            handler: handler)
    }

    // MARK: POST

    public func route<Result: Encodable>(
        post path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            middleware: middleware,
            handler: handler)
    }

    // MARK: PUT

    public func route<Result: Encodable>(
        put path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            middleware: middleware,
            handler: handler)
    }

    // MARK: DELETE

    public func route<Result: Encodable>(
        delete path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            middleware: middleware,
            handler: handler)
    }

    // MARK: OPTIONS

    public func route<Result: Encodable>(
        options path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            middleware: middleware,
            handler: handler)
    }

    // MARK: ALL

    public func route<Result: Encodable>(
        all path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [ControllerMiddleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            middleware: middleware,
            handler: handler)
    }
}
