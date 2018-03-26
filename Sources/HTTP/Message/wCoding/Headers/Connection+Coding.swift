import Stream

extension Connection {
    private struct Bytes {
        static let keepAlive = ASCII("keep-alive")
        static let close = ASCII("close")
        static let upgrade = ASCII("Upgrade")
    }

    init<T: StreamReader>(from stream: T) throws {
        // FIXME: validate with value-specific rule
        self = try stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.keepAlive.lowercasedHashValue: return .keepAlive
            case Bytes.close.lowercasedHashValue: return .close
            case Bytes.upgrade.lowercasedHashValue: return .upgrade
            default: throw ParseError.unsupportedContentType
            }
        }
    }

    func encode<T: StreamWriter>(to stream: T) throws {
        let bytes: [UInt8]
        switch self {
        case .keepAlive: bytes = Bytes.keepAlive
        case .close: bytes = Bytes.close
        case .upgrade: bytes = Bytes.upgrade
        }
        try stream.write(bytes)
    }
}
