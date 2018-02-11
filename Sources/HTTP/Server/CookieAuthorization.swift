public final class CookieAuthorization: AuthorizationProtocol, InjectService {
    let repository: UserRepository

    public init(_ repository: UserRepository) {
        self.repository = repository
    }

    func authenticate(context: Context) throws {
        guard let userId = context.cookies["swift-stack-user"] else {
            context.user = nil
            return
        }
        context.user = try repository.get(id: userId)
    }

    func loginRequired(context: Context) {
        context.response = Response(status: .unauthorized)
    }

    func accessDenied(context: Context) {
        context.response = Response(status: .unauthorized)
    }
}
