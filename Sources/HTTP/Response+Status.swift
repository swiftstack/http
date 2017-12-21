import Stream

extension Response {
    public enum Status {
        case ok
        case moved
        case badRequest
        case unauthorized
        case notFound
        case internalServerError
    }
}

extension Response.Status {
    private struct Bytes {
        static let ok = ASCII("200 OK")
        static let moved = ASCII("301 Moved Permanently")
        static let badRequest = ASCII("400 Bad Request")
        static let unauthorized = ASCII("401 Unauthorized")
        static let notFound = ASCII("404 Not Found")
        static let internalServerError = ASCII("500 Internal Server Error")
    }

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        switch bytes.lowercasedHashValue {
        case Bytes.ok.lowercasedHashValue: self = .ok
        case Bytes.moved.lowercasedHashValue: self = .moved
        case Bytes.badRequest.lowercasedHashValue: self = .badRequest
        case Bytes.unauthorized.lowercasedHashValue: self = .unauthorized
        case Bytes.notFound.lowercasedHashValue: self = .notFound
        case Bytes.internalServerError.lowercasedHashValue:
            self = .internalServerError
        default: throw HTTPError.invalidStatus
        }
    }

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        let bytes: [UInt8]
        switch self {
        case .ok: bytes = Bytes.ok
        case .moved: bytes = Bytes.moved
        case .badRequest: bytes = Bytes.badRequest
        case .unauthorized: bytes = Bytes.unauthorized
        case .notFound: bytes = Bytes.notFound
        case .internalServerError: bytes = Bytes.internalServerError
        }
        try stream.write(bytes)
    }
}
