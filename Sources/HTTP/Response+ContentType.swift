extension Response {
    public enum ContentType {
        case text
        case html
        case stream
        case json
    }
}

extension Response.ContentType {
    private struct StatusCodeMapping {
        static let text = ASCII("text/plain")
        static let html = ASCII("text/html")
        static let stream = ASCII("aplication/stream")
        static let json = ASCII("application/json")
    }

    var bytes: [UInt8] {
        switch self {
        case .text: return StatusCodeMapping.text
        case .html: return StatusCodeMapping.html
        case .stream: return StatusCodeMapping.stream
        case .json: return StatusCodeMapping.json
        }
    }
}
