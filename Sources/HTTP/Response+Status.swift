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

    public init(from bytes: UnsafeRawBufferPointer) throws {
        if bytes.elementsEqual(Bytes.ok) {
            self = .ok
        } else if bytes.elementsEqual(Bytes.moved) {
            self = .moved
        } else if bytes.elementsEqual(Bytes.badRequest) {
            self = .badRequest
        } else if bytes.elementsEqual(Bytes.unauthorized) {
            self = .unauthorized
        } else if bytes.elementsEqual(Bytes.notFound) {
            self = .notFound
        } else if bytes.elementsEqual(Bytes.internalServerError) {
            self = .internalServerError
        } else {
            throw HTTPError.invalidStatus
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .ok: buffer.append(contentsOf: Bytes.ok)
        case .moved: buffer.append(contentsOf: Bytes.moved)
        case .badRequest: buffer.append(contentsOf: Bytes.badRequest)
        case .unauthorized: buffer.append(contentsOf: Bytes.unauthorized)
        case .notFound: buffer.append(contentsOf: Bytes.notFound)
        case .internalServerError: buffer.append(contentsOf: Bytes.internalServerError)
        }
    }
}
