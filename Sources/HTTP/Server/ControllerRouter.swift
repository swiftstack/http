public class ControllerRouter<T: Controller> {
    let services: Services
    @_versioned let application: Application
    @_versioned let middleware: [ControllerMiddleware.Type]
    @_versioned let authorization: Authorization
    var constructor: (Context) throws -> T

    public init(
        basePath: String,
        middleware: [ControllerMiddleware.Type],
        authorization: Authorization,
        services: Services,
        controllerConstructor constructor: @escaping (Context) throws -> T
    ) {
        self.services = services
        self.application = Application(basePath: basePath)
        self.middleware = middleware
        self.authorization = authorization
        self.constructor = constructor
    }

    func chainMiddleware(
        _ middleware: [ControllerMiddleware.Type],
        with handler: @escaping (Context) throws -> Void
    ) -> (Context) throws -> Void {
        var handler = handler
        for next in middleware.reversed() {
            handler = next.chain(with: handler)
        }
        return handler
    }

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
    //
    //     let response = callMiddlewareChain(last: { context in
    //         let controller = try self.constructor(context)
    //         let handler = handlerConstructor(controller)
    //
    //         let result = controllerHandler(...)
    //
    //         let request = context.request
    //         let response = context.response
    //         try Coder.updateRespone(response, for: request, encoding: result)
    //         return response
    //     })
    //     return context.response
    // }

    @_versioned
    func makeMiddleware<Result: Encodable>(
        for path: String,
        wrapping accessor: @escaping (T) -> () throws -> Result
    ) -> (Context) throws -> Void {
        return { context in
            let controller = try self.constructor(context)
            let handler = accessor(controller)
            let result = try handler()
            let request = context.request
            let response = context.response
            try Coder.updateRespone(response, for: request, encoding: result)
        }
    }

    @_versioned
    func makeMiddleware<Model: Decodable, Result: Encodable>(
        for path: String,
        wrapping accessor: @escaping (T) -> (Model) throws -> Result
    ) -> (Context) throws -> Void {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(path)

        if urlMatcher.params.count > 0 {
            return { context in
                let controller = try self.constructor(context)
                let handler = accessor(controller)

                let request = context.request
                let response = context.response

                let values = urlMatcher.match(from: context.request.url.path)
                let match = try keyValueDecoder.decode(Model.self, from: values)
                let result = try handler(match)
                try Coder.updateRespone(
                    response, for: request, encoding: result)
            }
        } else {
            return { context in
                let controller = try self.constructor(context)
                let handler = accessor(controller)

                let request = context.request
                let response = context.response

                let model = try Coder.decodeModel(Model.self, from: request)
                let result = try handler(model)
                try Coder.updateRespone(
                    response, for: request, encoding: result)
            }
        }
    }

    @_versioned
    func makeMiddleware
    <
        URLMatch: Decodable, Model: Decodable, Result: Encodable
    >(
        for path: String,
        wrapping accessor: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) -> (Context) throws -> Void {
        let keyValueDecoder = KeyValueDecoder()
        let urlMatcher = URLParamMatcher(path)

        guard urlMatcher.params.count > 0 else {
            fatalError("invalid url mask, more than 0 arguments were expected")
        }

        return { context in
            let controller = try self.constructor(context)
            let handler = accessor(controller)

            let request = context.request
            let response = context.response

            let values = urlMatcher.match(from: request.url.path)
            let match = try keyValueDecoder.decode(URLMatch.self, from: values)
            let model = try Coder.decodeModel(Model.self, from: request)
            let result = try handler(match, model)
            try Coder.updateRespone(response, for: request, encoding: result)
        }
    }

    // controller handler <-> http handler

    @_versioned
    func makeHandler(
        through middleware: [ControllerMiddleware.Type],
        to handler: @escaping (Context) throws -> Void,
        authorize authorization: Authorization
    ) -> RequestHandler {
        let middleware = self.middleware + middleware
        let chain = chainMiddleware(middleware, with: handler)

        return { (request: Request) throws -> Response in
            let context = Context(
                request: request,
                authorization: authorization,
                services: self.services)
            try chain(context)
            return context.response
        }
    }

    // MARK: Base routes

    @_inlineable
    public func route<Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        authorization: Authorization?,
        middleware: [ControllerMiddleware.Type] = [],
        handler: @escaping (T) -> () throws -> Result
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization ?? self.authorization)
        application.route(path: path, methods: methods, handler: handler)
    }

    @_inlineable
    public func route<Model: Decodable, Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        authorization: Authorization?,
        middleware: [ControllerMiddleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Result
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization ?? self.authorization)
        application.route(path: path, methods: methods, handler: handler)
    }

    @_inlineable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        path: String,
        methods: Router.MethodSet,
        authorization: Authorization?,
        middleware: [ControllerMiddleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization ?? self.authorization)
        application.route(path: path, methods: methods, handler: handler)
    }
}
