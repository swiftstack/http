public final class CookieAuthorization: AuthorizationProtocol, InjectService {
    static var userCookieName = "swift-stack-user"

    let repository: UserRepository

    public init(_ repository: UserRepository) {
        self.repository = repository
    }

    func authenticate(context: Context) throws {
        let cookieName = CookieAuthorization.userCookieName
        guard let userId = context.cookies[cookieName] else {
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
