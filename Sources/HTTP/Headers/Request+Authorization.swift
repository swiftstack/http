extension Request {
    public enum Authorization {
        case basic(credentials: String)
        case bearer(credentials: String)
    }
}

extension Request.Authorization: Equatable {
    public typealias Authorization = Request.Authorization
    public static func ==(lhs: Authorization, rhs: Authorization) -> Bool {
        switch (lhs, rhs) {
        case let (.basic(lhs), .basic(rhs)) where lhs == rhs: return true
        case let (.bearer(lhs), .bearer(rhs)) where lhs == rhs: return true
        default: return false
        }
    }
}

extension Request.Authorization {
    private struct Bytes {
        static let basic = ASCII("Basic")
        static let bearer = ASCII("Bearer")
    }

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        func suffix(from index: Int) throws -> String {
            let index = bytes.startIndex + index + 1
            guard index > bytes.startIndex, index < bytes.endIndex,
                bytes[index-1] == Character.whitespace else {
                    throw HTTPError.invalidHeaderValue
            }
            return String(buffer: bytes[index...])
        }

        switch bytes {
        case _ where bytes.starts(with: Bytes.basic):
            let credentials = try suffix(from: Bytes.basic.count)
            self = .basic(credentials: credentials)
        case _ where bytes.starts(with: Bytes.bearer):
            let credentials = try suffix(from: Bytes.bearer.count)
            self = .bearer(credentials: credentials)
        default:
            throw HTTPError.unsupportedAuthorization
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .basic(let credentials):
            buffer.append(contentsOf: Bytes.basic)
            buffer.append(Character.whitespace)
            buffer.append(contentsOf: credentials.utf8)
        case .bearer(let credentials):
            buffer.append(contentsOf: Bytes.bearer)
            buffer.append(Character.whitespace)
            buffer.append(contentsOf: credentials.utf8)
        }
    }
}
