public struct AuthorizationMiddleware: ControllerMiddleware {
    public static func chain(
        with middleware: @escaping (Context) throws -> Void
    ) -> (Context) throws -> Void {
        return { context in
            let auth = try context.services.resolve(AuthorizationProtocol.self)
            try auth.authenticate(context: context)
            guard context.authorization.authorize(user: context.user) else {
                return auth.authorizationFailed(context: context)
            }
            try middleware(context)
        }
    }
}
