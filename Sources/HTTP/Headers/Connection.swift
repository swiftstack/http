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

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        // FIXME: validate with value-specific rule
        let bytes = try stream.read(allowedBytes: .token)
        switch bytes.lowercasedHashValue {
        case Bytes.keepAlive.lowercasedHashValue: self = .keepAlive
        case Bytes.close.lowercasedHashValue: self = .close
        case Bytes.upgrade.lowercasedHashValue: self = .upgrade
        default: throw HTTPError.unsupportedContentType
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .keepAlive: buffer.append(contentsOf: Bytes.keepAlive)
        case .close: buffer.append(contentsOf: Bytes.close)
        case .upgrade: buffer.append(contentsOf: Bytes.upgrade)
        }
    }
}
