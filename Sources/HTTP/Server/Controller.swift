import JSON

public protocol Controller {
    static var basePath: String { get }
    static var middleware: [Middleware.Type] { get }
    static func setup(router: ControllerRouter<Self>) throws
}

public extension Controller {
    static var basePath: String {
        return ""
    }

    static var middleware: [Middleware.Type] {
        return []
    }
}

extension RouterProtocol {
    func addController<C: Controller>(
        _ controller: C.Type,
        constructor: @escaping () throws -> C
    ) throws {
        let router = ControllerRouter<C>(
            basePath: C.basePath,
            middleware: C.middleware,
            controllerConstructor: constructor
        )
        try C.setup(router: router)
        self.addApplication(router.application)
    }

    func check<T, C: Controller>(
        type: T.Type,
        for controller: C.Type
    ) throws {
        do {
            _ = try Services.shared.resolve(T.self)
        } catch let error as Services.Error {
            debugPrint(controller)
            throw error
        }
    }
}

public class ControllerRouter<T: Controller> {
    let application: Application
    var constructor: () throws -> T

    public init(
        basePath: String,
        middleware: [Middleware.Type],
        controllerConstructor: @escaping () throws -> T
    ) {
        application = Application(basePath: basePath, middleware: middleware)
        constructor = controllerConstructor
    }

    //    @escaping () throws -> Response
    //    @escaping (Request) throws -> Response
    //    @escaping (Model) throws -> Response
    //    @escaping (Request, Model) throws -> Response
    //    @escaping (URLMatch, Model) throws -> Response
    //    @escaping (Request, URLMatch, Model) throws -> Response

    //    -@escaping () throws -> Result
    //    @escaping (Request) throws -> Result
    //    @escaping (Model) throws -> Result
    //    @escaping (Request, Model) throws -> Result
    //    @escaping (URLMatch, Model) throws -> Result
    //    @escaping (Request, URLMatch, Model) throws -> Result

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

    public func route<Result: Encodable>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Result
    ) {
        application.route(get: path, middleware: middleware)
        { (request: Request) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler()
        }
    }

    public func route<Model, Result>(
        get path: String,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Result)
        where Model: Decodable, Result: Encodable
    {
        application.route(get: path, middleware: middleware)
        { (request: Request, model: Model) -> Result in
            let controller = try self.constructor()
            let handler = handler(controller)
            return try handler(model)
        }
    }
}
