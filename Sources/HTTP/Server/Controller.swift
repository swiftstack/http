import JSON

public protocol Controller {
    static var basePath: String { get }
    static var middleware: [ControllerMiddleware.Type] { get }
    static func setup(router: ControllerRouter<Self>) throws
}

public protocol ControllerMiddleware {
    static func chain(
        with middleware: @escaping (Context) throws -> Void
    ) -> (Context) throws -> Void
}

public extension Controller {
    static var basePath: String {
        return ""
    }

    static var middleware: [ControllerMiddleware.Type] {
        return []
    }
}

extension RouterProtocol {
    func addController<C: Controller>(
        _ controller: C.Type,
        constructor: @escaping (Context) throws -> C
    ) throws {
        let router = ControllerRouter<C>(
            basePath: C.basePath,
            middleware: C.middleware,
            services: Services.shared,
            controllerConstructor: constructor
        )
        try C.setup(router: router)
        self.addApplication(router.application)
    }
}
