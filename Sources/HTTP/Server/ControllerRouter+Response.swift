// Convenience routes

extension ControllerRouter {

    // MARK: GET

    public func route(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Response
    ) {
        application.route(get: path, middleware: middleware)
        { () -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Response
    ) {
        application.route(get: path, middleware: middleware)
        { (request: Request) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Response
    ) {
        application.route(get: path, middleware: middleware)
        { (model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Response
    ) {
        application.route(get: path, middleware: middleware)
        { (request: Request, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Response
    ) {
        application.route(get: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Response
    ) {
        application.route(get: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: HEAD

    public func route(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Response
    ) {
        application.route(head: path, middleware: middleware)
        { () -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Response
    ) {
        application.route(head: path, middleware: middleware)
        { (request: Request) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Response
    ) {
        application.route(head: path, middleware: middleware)
        { (model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Response
    ) {
        application.route(head: path, middleware: middleware)
        { (request: Request, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Response
    ) {
        application.route(head: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        head path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Response
    ) {
        application.route(head: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: POST

    public func route(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Response
    ) {
        application.route(post: path, middleware: middleware)
        { () -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Response
    ) {
        application.route(post: path, middleware: middleware)
        { (request: Request) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Response
    ) {
        application.route(post: path, middleware: middleware)
        { (model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Response
    ) {
        application.route(post: path, middleware: middleware)
        { (request: Request, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Response
    ) {
        application.route(post: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        post path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Response
    ) {
        application.route(post: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: PUT

    public func route(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Response
    ) {
        application.route(put: path, middleware: middleware)
        { () -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Response
    ) {
        application.route(put: path, middleware: middleware)
        { (request: Request) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Response
    ) {
        application.route(put: path, middleware: middleware)
        { (model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Response
    ) {
        application.route(put: path, middleware: middleware)
        { (request: Request, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Response
    ) {
        application.route(put: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        put path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Response
    ) {
        application.route(put: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: DELETE

    public func route(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Response
    ) {
        application.route(delete: path, middleware: middleware)
        { () -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Response
    ) {
        application.route(delete: path, middleware: middleware)
        { (request: Request) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Response
    ) {
        application.route(delete: path, middleware: middleware)
        { (model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Response
    ) {
        application.route(delete: path, middleware: middleware)
        { (request: Request, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Response
    ) {
        application.route(delete: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        delete path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Response
    ) {
        application.route(delete: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: OPTIONS

    public func route(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Response
    ) {
        application.route(options: path, middleware: middleware)
        { () -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Response
    ) {
        application.route(options: path, middleware: middleware)
        { (request: Request) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Response
    ) {
        application.route(options: path, middleware: middleware)
        { (model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Response
    ) {
        application.route(options: path, middleware: middleware)
        { (request: Request, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Response
    ) {
        application.route(options: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        options path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Response
    ) {
        application.route(options: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }

    // MARK: ALL

    public func route(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Response
    ) {
        application.route(all: path, middleware: middleware)
        { () -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request) throws -> Response
    ) {
        application.route(all: path, middleware: middleware)
        { (request: Request) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request)
        }
    }

    public func route<Model: Decodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Response
    ) {
        application.route(all: path, middleware: middleware)
        { (model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }

    public func route<Model: Decodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, Model) throws -> Response
    ) {
        application.route(all: path, middleware: middleware)
        { (request: Request, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Response
    ) {
        application.route(all: path, middleware: middleware)
        { (match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(match, model)
        }
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        all path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Request, URLMatch, Model) throws -> Response
    ) {
        application.route(all: path, middleware: middleware)
        { (request: Request, match: URLMatch, model: Model) -> Response in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(request, match, model)
        }
    }
}
