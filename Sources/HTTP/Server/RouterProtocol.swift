// We want the same '.route' APIs for Server and Application
// but while Server registers it directly in the Router
// Application needs to store them until it get passed to the Server

public protocol RouterProtocol: class {
    var middleware: [Middleware.Type] { get set }

    func registerRoute(
        path: String,
        methods: Router.MethodSet,
        middleware: [Middleware.Type],
        handler: @escaping RequestHandler
    )
}
