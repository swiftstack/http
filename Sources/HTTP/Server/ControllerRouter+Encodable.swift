// Convenience routes

extension ControllerRouter {

    // MARK: GET

    public func route<Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(get: path, through: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(get: path, through: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(get: path, through: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(get: path, through: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(get: path, through: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(get: path, through: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: HEAD

    public func route<Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(head: path, through: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(head: path, through: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(head: path, through: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(head: path, through: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(head: path, through: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(head: path, through: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: POST

    public func route<Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(post: path, through: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(post: path, through: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(post: path, through: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(post: path, through: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(post: path, through: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(post: path, through: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: PUT

    public func route<Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(put: path, through: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(put: path, through: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(put: path, through: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(put: path, through: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(put: path, through: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(put: path, through: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: DELETE

    public func route<Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(delete: path, through: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(delete: path, through: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(delete: path, through: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(delete: path, through: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(delete: path, through: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(delete: path, through: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: OPTIONS

    public func route<Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(options: path, through: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(options: path, through: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(options: path, through: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(options: path, through: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(options: path, through: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(options: path, through: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: ALL

    public func route<Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(all: path, through: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(all: path, through: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(all: path, through: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(all: path, through: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(all: path, through: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        to handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(all: path, through: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }
}
