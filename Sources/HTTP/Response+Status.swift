extension Response {
    public enum Status: String {
        case ok
        case moved
        case badRequest
        case unauthorized
        case notFound
        case internalServerError
    }
}

extension Response.Status {
    private struct StatusCodeMapping {
        static let ok = ASCII("200 OK")
        static let moved = ASCII("301 Moved Permanently")
        static let badRequest = ASCII("400 Bad Request")
        static let unauthorized = ASCII("401 Unauthorized")
        static let notFound = ASCII("404 Not Found")
        static let internalServerError = ASCII("500 Internal Server Error")
    }

    var bytes: [UInt8] {
        switch self {
        case .ok: return StatusCodeMapping.ok
        case .moved: return StatusCodeMapping.moved
        case .badRequest: return StatusCodeMapping.badRequest
        case .unauthorized: return StatusCodeMapping.unauthorized
        case .notFound: return StatusCodeMapping.notFound
        case .internalServerError: return StatusCodeMapping.internalServerError
        }
    }
}
