import Stream

extension Request {
    public enum Authorization {
        case basic(credentials: String)
        case bearer(credentials: String)
        case token(credentials: String)
        case custom(scheme: String, credentials: String)
    }
}

extension Request.Authorization: Equatable {
    public typealias Authorization = Request.Authorization
    public static func ==(lhs: Authorization, rhs: Authorization) -> Bool {
        switch (lhs, rhs) {
        case let (.basic(lhs), .basic(rhs)) where lhs == rhs: return true
        case let (.bearer(lhs), .bearer(rhs)) where lhs == rhs: return true
        case let (.token(lhs), .token(rhs)) where lhs == rhs: return true
        case let (.custom(lhs), .custom(rhs)) where lhs == rhs: return true
        default: return false
        }
    }
}

extension Request.Authorization {
    private struct Bytes {
        static let basic = ASCII("Basic")
        static let bearer = ASCII("Bearer")
        static let token = ASCII("Token")
    }

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        var buffer = try stream.read(until: .whitespace)
        let schemeHashValue = buffer.lowercasedHashValue

        func readCredentials() throws -> String {
            guard try stream.consume(.whitespace) else {
                throw HTTPError.invalidAuthorizationHeader
            }
            // FIXME: validate with value-specific rule
            buffer = try stream.read(allowedBytes: .text)
            return String(decoding: buffer, as: UTF8.self)
        }

        switch schemeHashValue {
        case Bytes.basic.lowercasedHashValue:
            self = .basic(credentials: try readCredentials())
        case Bytes.bearer.lowercasedHashValue:
            self = .bearer(credentials: try readCredentials())
        case Bytes.token.lowercasedHashValue:
            self = .token(credentials: try readCredentials())
        default:
            let scheme = String(decoding: buffer, as: UTF8.self)
            self = .custom(scheme: scheme, credentials:  try readCredentials())
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .basic(let credentials):
            buffer.append(contentsOf: Bytes.basic)
            buffer.append(.whitespace)
            buffer.append(contentsOf: credentials.utf8)
        case .bearer(let credentials):
            buffer.append(contentsOf: Bytes.bearer)
            buffer.append(.whitespace)
            buffer.append(contentsOf: credentials.utf8)
        case .token(let credentials):
            buffer.append(contentsOf: Bytes.token)
            buffer.append(.whitespace)
            buffer.append(contentsOf: credentials.utf8)
        case .custom(let schema, let credentials):
            buffer.append(contentsOf: schema.utf8)
            buffer.append(.whitespace)
            buffer.append(contentsOf: credentials.utf8)
        }
    }
}
