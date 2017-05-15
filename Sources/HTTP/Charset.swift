public enum Charset {
    case isoLatin1
    case utf8
    case any
    case custom(String)
}

extension Charset: Equatable {
    public static func ==(lhs: Charset, rhs: Charset) -> Bool {
        switch (lhs, rhs) {
        case (.isoLatin1, .isoLatin1): return true
        case (.utf8, .utf8): return true
        case (.any, .any): return true
        case let (.custom(lhs), .custom(rhs)): return lhs == rhs
        default: return false
        }
    }
}

extension Charset {
    private struct Bytes {
        static let isoLatin1 = ASCII("ISO-8859-1")
        static let utf8 = ASCII("utf-8")
        static let any = ASCII("*")
    }

    init(from bytes: UnsafeRawBufferPointer) throws {
        switch bytes.lowercasedHashValue {
        case Bytes.utf8.lowercasedHashValue: self = .utf8
        case Bytes.isoLatin1.lowercasedHashValue: self = .isoLatin1
        case Bytes.any.lowercasedHashValue: self = .any
        default: self = .custom(String(buffer: bytes))
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .utf8: buffer.append(contentsOf: Bytes.utf8)
        case .isoLatin1: buffer.append(contentsOf: Bytes.isoLatin1)
        case .any: buffer.append(contentsOf: Bytes.any)
        case .custom(let value): buffer.append(contentsOf: [UInt8](value))
        }
    }
}
