// Convenience routes

extension ControllerRouter {

    // Boilerplate for convenience routes:
    //
    // available handlers:
    //
    // () -> Encodable
    // (URLMatch or Model) -> Encodable
    // (URLMatch, Model) -> Encodable
    //
    // result:
    //
    // application.route { request, ... in
    //     let context = Context(request: request, services: self.services)
    //     let controller = try self.constructor(context)
    //     let handler = handlerConstructor(controller)
    //
    //     let result = controllerHandler(...)
    //
    //     let response = context.response
    //     try Coder.updateRespone(response, for: request, encoding: result)
    //     return context.response
    // }

    func makeController<Result: Encodable>(
        for request: Request,
        _ controllerHandler: (T) throws -> Result
    ) throws -> Response {
        let context = Context(request: request, services: self.services)
        let controller = try self.constructor(context)
        let result = try controllerHandler(controller)
        let response = context.response
        try Coder.updateRespone(response, for: request, encoding: result)
        return response
    }

    // controller handler <-> http handler

    func makeHandler<Result: Encodable>(
        for handlerConstructor: @escaping (T) -> () throws -> Result
    ) -> (Request) throws -> Response {
        return { (request: Request) throws -> Response in
            return try self.makeController(for: request)
            { (controller: T) -> Result in
                let handler = handlerConstructor(controller)
                return try handler()
            }
        }
    }

    func makeHandler<Model: Decodable, Result: Encodable>(
        for handler: @escaping (T) -> (Model) throws -> Result
    ) -> (Request, Model) throws -> Response {
        return { (request: Request, model: Model) throws -> Response in
            return try self.makeController(for: request)
            { (controller: T) -> Result in
                let handler = handler(controller)
                return try handler(model)
            }
        }
    }

    func makeHandler<U: Decodable, M: Decodable, Result: Encodable>(
        for handler: @escaping (T) -> (U, M) throws -> Result
    ) -> (Request, U, M) throws -> Response {
        return { (request: Request, urlMatch: U, model: M) throws -> Response in
            return try self.makeController(for: request)
            { (controller: T) -> Result in
                let handler = handler(controller)
                return try handler(urlMatch, model)
            }
        }
    }

    // MARK: GET

    public func route<Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(get: path, to: makeHandler(for: handler))
    }

    public func route<Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(get: path, to: makeHandler(for: handler))
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(get: path, to: makeHandler(for: handler))
    }

    // MARK: HEAD

    public func route<Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(head: path, to: makeHandler(for: handler))
    }

    public func route<Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(head: path, to: makeHandler(for: handler))
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(head: path, to: makeHandler(for: handler))
    }

    // MARK: POST

    public func route<Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(post: path, to: makeHandler(for: handler))
    }

    public func route<Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(post: path, to: makeHandler(for: handler))
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(post: path, to: makeHandler(for: handler))
    }

    // MARK: PUT

    public func route<Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(put: path, to: makeHandler(for: handler))
    }

    public func route<Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(put: path, to: makeHandler(for: handler))
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(put: path, to: makeHandler(for: handler))
    }

    // MARK: DELETE

    public func route<Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(delete: path, to: makeHandler(for: handler))
    }

    public func route<Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(delete: path, to: makeHandler(for: handler))
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(delete: path, to: makeHandler(for: handler))
    }

    // MARK: OPTIONS

    public func route<Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(options: path, to: makeHandler(for: handler))
    }

    public func route<Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(options: path, to: makeHandler(for: handler))
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(options: path, to: makeHandler(for: handler))
    }

    // MARK: ALL

    public func route<Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(all: path, to: makeHandler(for: handler))
    }

    public func route<Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(all: path, to: makeHandler(for: handler))
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(all: path, to: makeHandler(for: handler))
    }
}
