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

    init<T: StreamReader>(from reader: T) throws {
        self = try reader.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.utf8.lowercasedHashValue: return .utf8
            case Bytes.ascii.lowercasedHashValue: return .ascii
            case Bytes.isoLatin1.lowercasedHashValue: return .isoLatin1
            case Bytes.any.lowercasedHashValue: return .any
            default: return .custom(String(decoding: bytes, as: UTF8.self))
            }
        }
    }

    func encode<T: StreamWriter>(to stream: T) throws {
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
