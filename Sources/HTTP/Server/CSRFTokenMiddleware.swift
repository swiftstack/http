import struct Foundation.UUID

public struct CSRFTokenMiddleware: ControllerMiddleware {
    static var tokenCookieName = "X-CSRF-Token"
    static var tokenHeaderName: HeaderName = "X-CSRF-Token"

    public static func chain(
        with middleware: @escaping (Context) throws -> Void
    ) -> (Context) throws -> Void {
        return { context in
            guard context.user != nil else {
                try middleware(context)
                if context.user != nil {
                    // logged in
                    let token = UUID().uuidString
                    context.cookies[tokenCookieName] = token
                    context.response.headers[tokenHeaderName] = token
                }
                return
            }

            // validate token
            guard let token = context.cookies[tokenCookieName],
                context.request.headers[tokenHeaderName] == token else {
                    context.response = Response(status: .unauthorized)
                    return
            }
            try middleware(context)

            // logged out
            if context.user == nil {
                context.cookies[tokenCookieName] = nil
            }
        }
    }
}
