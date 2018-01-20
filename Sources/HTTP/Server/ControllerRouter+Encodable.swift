// Convenience routes

extension ControllerRouter {

    // MARK: GET

    public func route<Result: Encodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(get: path, middleware: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(get: path, middleware: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(get: path, middleware: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(get: path, middleware: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(get: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(get: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: HEAD

    public func route<Result: Encodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(head: path, middleware: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(head: path, middleware: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(head: path, middleware: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(head: path, middleware: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(head: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(head: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: POST

    public func route<Result: Encodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(post: path, middleware: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(post: path, middleware: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(post: path, middleware: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(post: path, middleware: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(post: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(post: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: PUT

    public func route<Result: Encodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(put: path, middleware: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(put: path, middleware: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(put: path, middleware: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(put: path, middleware: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(put: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(put: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: DELETE

    public func route<Result: Encodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(delete: path, middleware: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(delete: path, middleware: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(delete: path, middleware: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(delete: path, middleware: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(delete: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(delete: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: OPTIONS

    public func route<Result: Encodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(options: path, middleware: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(options: path, middleware: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(options: path, middleware: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(options: path, middleware: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(options: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(options: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: ALL

    public func route<Result: Encodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(all: path, middleware: middleware)
        { () -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Result: Encodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Result
    ) {
        application.route(all: path, middleware: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Result
    ) {
        application.route(all: path, middleware: middleware)
        { (model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable, Result: Encodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Result
    ) {
        application.route(all: path, middleware: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        application.route(all: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Result
    ) {
        application.route(all: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }
}
