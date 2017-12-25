import Log

public protocol Middleware {
    static func createMiddleware(
        for handler: @escaping RequestHandler
    ) -> RequestHandler
}

public struct LogMiddleware: Middleware {
    public static func createMiddleware(
        for handler: @escaping RequestHandler
    ) -> RequestHandler {
        return { request in
            Log.debug(">> \(request.url.path)")
            let response = try handler(request)
            Log.debug("<< \(response.status)")
            return response
        }
    }
}
