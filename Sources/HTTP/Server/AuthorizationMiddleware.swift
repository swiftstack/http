public struct AuthorizationMiddleware: ControllerMiddleware {
    public static func chain(
        with middleware: @escaping (Context) throws -> Void
    ) -> (Context) throws -> Void {
        return { context in
            let auth = try context.services.resolve(AuthorizationProtocol.self)
            try auth.authenticate(context: context)
            let result = context.authorization.authorize(user: context.user)
            switch result {
            case .ok: try middleware(context)
            case .unauthorized: auth.accessDenied(context: context)
            case .unauthenticated: auth.loginRequired(context: context)
            }
        }
    }
}
