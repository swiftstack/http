extension Server: RouterProtocol {
    func registerRoute(
        methods: Router.MethodSet,
        url: String,
        middleware: [Middleware.Type],
        handler: @escaping RequestHandler
    ) {
        router.registerRoute(
            methods: methods,
            url: url,
            middleware: middleware,
            handler: handler)
    }
}
