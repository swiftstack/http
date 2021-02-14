import Log

public protocol Middleware {
    static func chain(with handler: @escaping RequestHandler) -> RequestHandler
}

public struct LogMiddleware: Middleware {
    public static func chain(
        with handler: @escaping RequestHandler
    ) -> RequestHandler {
        return { request in
            await Log.debug(">> \(request.url.path)")
            let response = try await handler(request)
            await Log.debug("<< \(response.status)")
            return response
        }
    }
}

public struct ErrorHandlerMiddleware: Middleware {
    public static func chain(
        with handler: @escaping RequestHandler
    ) -> RequestHandler {
        return { request in
            do {
                return try await handler(request)
            } catch {
                switch error {
                case let error as Server.Error:
                    switch error {
                    case .notFound:
                        await Log.warning("not found: \(request.url.path)")
                        return Response(status: .notFound)
                    case .conflict:
                        return Response(status: .conflict)
                    case .internalServerError:
                        return Response(status: .internalServerError)
                    }
                default:
                    throw error
                }
            }
        }
    }
}
