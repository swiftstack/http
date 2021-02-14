import Stream

extension Connection {
    private struct Bytes {
        static let keepAlive = ASCII("keep-alive")
        static let close = ASCII("close")
        static let upgrade = ASCII("Upgrade")
    }

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        // FIXME: validate with value-specific rule
        return try await stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.keepAlive.lowercasedHashValue: return .keepAlive
            case Bytes.close.lowercasedHashValue: return .close
            case Bytes.upgrade.lowercasedHashValue: return .upgrade
            default: throw Error.unsupportedContentType
            }
        }
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        let bytes: [UInt8]
        switch self {
        case .keepAlive: bytes = Bytes.keepAlive
        case .close: bytes = Bytes.close
        case .upgrade: bytes = Bytes.upgrade
        }
        try await stream.write(bytes)
    }
}
