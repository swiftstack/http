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

    public init(from bytes: UnsafeRawBufferPointer.SubSequence) throws {
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

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .ok: buffer.append(contentsOf: Bytes.ok)
        case .moved: buffer.append(contentsOf: Bytes.moved)
        case .badRequest: buffer.append(contentsOf: Bytes.badRequest)
        case .unauthorized: buffer.append(contentsOf: Bytes.unauthorized)
        case .notFound: buffer.append(contentsOf: Bytes.notFound)
        case .internalServerError:
            buffer.append(contentsOf: Bytes.internalServerError)
        }
    }
}
