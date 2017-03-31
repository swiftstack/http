extension Request {
    public enum Kind {
        case get
        case head
        case post
        case put
        case delete
        case options
    }
}

extension Request.Kind {
    init(from buffer: UnsafeRawBufferPointer) throws {
        for (type, bytes) in RequestKindBytes.values {
            if buffer.elementsEqual(bytes) {
                self = type
                return
            }
        }
        throw RequestError.invalidMethod
    }
}

fileprivate struct RequestKindBytes {
    static let values: [(Request.Kind, ASCII)] = [
        (.get, ASCII("GET")),
        (.head, ASCII("HEAD")),
        (.post, ASCII("POST")),
        (.put, ASCII("PUT")),
        (.delete, ASCII("DELETE"))
    ]
}
