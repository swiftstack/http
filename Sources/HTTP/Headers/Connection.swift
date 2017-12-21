import Stream

public enum Connection {
    case keepAlive
    case close
    case upgrade
}

extension Connection {
    private struct Bytes {
        static let keepAlive = ASCII("keep-alive")
        static let close = ASCII("close")
        static let upgrade = ASCII("Upgrade")
    }

    init<T: UnsafeStreamReader>(from stream: T) throws {
        // FIXME: validate with value-specific rule
        let bytes = try stream.read(allowedBytes: .token)
        switch bytes.lowercasedHashValue {
        case Bytes.keepAlive.lowercasedHashValue: self = .keepAlive
        case Bytes.close.lowercasedHashValue: self = .close
        case Bytes.upgrade.lowercasedHashValue: self = .upgrade
        default: throw HTTPError.unsupportedContentType
        }
    }

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        let bytes: [UInt8]
        switch self {
        case .keepAlive: bytes = Bytes.keepAlive
        case .close: bytes = Bytes.close
        case .upgrade: bytes = Bytes.upgrade
        }
        try stream.write(bytes)
    }
}
