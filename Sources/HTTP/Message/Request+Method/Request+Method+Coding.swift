import Stream

extension Request.Method {
    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        return try await stream.read(allowedBytes: .token) { bytes in
            guard bytes.count > 0 else {
                throw Error.unexpectedEnd
            }
            for (type, method) in RequestMethodBytes.values {
                if bytes.elementsEqual(method) {
                    return type
                }
            }
            throw Error.invalidMethod
        }
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        let bytes: [UInt8]
        switch self {
        case .get: bytes = RequestMethodBytes.get
        case .head: bytes = RequestMethodBytes.head
        case .post: bytes = RequestMethodBytes.post
        case .put: bytes = RequestMethodBytes.put
        case .delete: bytes = RequestMethodBytes.delete
        case .options: bytes = RequestMethodBytes.options
        }
        try await stream.write(bytes)
    }
}

fileprivate struct RequestMethodBytes {
    static let get = ASCII("GET")
    static let head = ASCII("HEAD")
    static let post = ASCII("POST")
    static let put = ASCII("PUT")
    static let delete = ASCII("DELETE")
    static let options = ASCII("OPTIONS")

    static let values: [(Request.Method, ASCII)] = [
        (.get, get),
        (.head, head),
        (.post, post),
        (.put, put),
        (.delete, delete),
        (.options, options),
    ]
}
