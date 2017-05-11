public enum Connection {
    case keepAlive
    case close
    case upgrade
}

extension Connection {
    init(from bytes: UnsafeRawBufferPointer) throws {
        switch bytes.lowercasedHashValue {
        case Mapping.keepAlive.lowercasedHashValue: self = .keepAlive
        case Mapping.close.lowercasedHashValue: self = .close
        case Mapping.upgrade.lowercasedHashValue: self = .upgrade
        default: throw HTTPError.unsupportedContentType
        }
    }
}

extension Connection {
    fileprivate struct Mapping {
        static let keepAlive = ASCII("keep-alive")
        static let close = ASCII("close")
        static let upgrade = ASCII("Upgrade")
    }

    var bytes: [UInt8] {
        switch self {
        case .keepAlive: return Mapping.keepAlive
        case .close: return Mapping.close
        case .upgrade: return Mapping.upgrade
        }
    }
}
