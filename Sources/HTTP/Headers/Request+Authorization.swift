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

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        func suffix(from index: Int) throws -> String {
            let index = bytes.startIndex + index + 1
            guard index > bytes.startIndex, index < bytes.endIndex,
                bytes[index-1] == .whitespace else {
                    throw HTTPError.invalidHeaderValue
            }
            guard let type =
                String(validating: bytes[index...], as: .text) else {
                    throw HTTPError.invalidHeaderValue
            }
            return type
        }

        guard let schemaEndIndex = bytes.index(of: .whitespace) else {
            throw HTTPError.invalidHeaderValue
        }
        let scheme = bytes[..<schemaEndIndex]

        switch scheme.lowercasedHashValue {
        case Bytes.basic.lowercasedHashValue:
            let credentials = try suffix(from: Bytes.basic.count)
            self = .basic(credentials: credentials)
        case Bytes.bearer.lowercasedHashValue:
            let credentials = try suffix(from: Bytes.bearer.count)
            self = .bearer(credentials: credentials)
        case Bytes.token.lowercasedHashValue:
            let token = try suffix(from: Bytes.token.count)
            self = .token(credentials: token)
        default:
            guard let scheme = String(validating: scheme, as: .text) else {
                throw HTTPError.invalidHeaderValue
            }
            let credentials = try suffix(from: schemaEndIndex)
            self = .custom(scheme: scheme, credentials: credentials)
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
