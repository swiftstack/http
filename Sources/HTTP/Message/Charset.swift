import Stream

public enum Charset: Equatable {
    case utf8
    case ascii
    case isoLatin1
    case any
    case custom(String)
}

extension Charset {
    private struct Bytes {
        static let utf8 = ASCII("utf-8")
        static let ascii = ASCII("US-ASCII")
        static let isoLatin1 = ASCII("ISO-8859-1")
        static let any = ASCII("*")
    }

    init<T: UnsafeStreamReader>(from stream: T) throws {
        let bytes = try stream.read(allowedBytes: .token)
        switch bytes.lowercasedHashValue {
        case Bytes.utf8.lowercasedHashValue: self = .utf8
        case Bytes.ascii.lowercasedHashValue: self = .ascii
        case Bytes.isoLatin1.lowercasedHashValue: self = .isoLatin1
        case Bytes.any.lowercasedHashValue: self = .any
        default: self = .custom(String(decoding: bytes, as: UTF8.self))
        }
    }

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        let bytes: [UInt8]
        switch self {
        case .utf8: bytes = Bytes.utf8
        case .ascii: bytes = Bytes.ascii
        case .isoLatin1: bytes = Bytes.isoLatin1
        case .any: bytes = Bytes.any
        case .custom(let value): bytes = [UInt8](value)
        }
        try stream.write(bytes)
    }
}
