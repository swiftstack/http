import Stream

extension Request {
    public enum Method {
        case get
        case head
        case post
        case put
        case delete
        case options
    }
}

extension Request.Method {
    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        let bytes = try stream.read(allowedBytes: .token)
        for (type, method) in RequestMethodBytes.values {
            if bytes.elementsEqual(method) {
                self = type
                return
            }
        }
        throw HTTPError.invalidMethod
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .get: buffer.append(contentsOf: RequestMethodBytes.get)
        case .head: buffer.append(contentsOf: RequestMethodBytes.head)
        case .post: buffer.append(contentsOf: RequestMethodBytes.post)
        case .put: buffer.append(contentsOf: RequestMethodBytes.put)
        case .delete: buffer.append(contentsOf: RequestMethodBytes.delete)
        case .options: buffer.append(contentsOf: RequestMethodBytes.options)
        }
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
