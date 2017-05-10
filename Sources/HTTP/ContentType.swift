public enum ContentType {
    case text
    case html
    case stream
    case json
    case urlEncoded
}

extension ContentType {
    init(from bytes: UnsafeRawBufferPointer) throws {
        switch bytes.lowercasedHashValue {
        case Mapping.text.lowercasedHashValue: self = .text
        case Mapping.html.lowercasedHashValue: self = .html
        case Mapping.stream.lowercasedHashValue: self = .stream
        case Mapping.json.lowercasedHashValue: self = .json
        case Mapping.urlEncoded.lowercasedHashValue: self = .urlEncoded
        default: throw HTTPError.unsupportedContentType
        }
    }
}

extension ContentType {
    fileprivate struct Mapping {
        static let text = ASCII("text/plain")
        static let html = ASCII("text/html")
        static let stream = ASCII("application/stream")
        static let json = ASCII("application/json")
        static let urlEncoded = ASCII("application/x-www-form-urlencoded")
    }

    var bytes: [UInt8] {
        switch self {
        case .text: return Mapping.text
        case .html: return Mapping.html
        case .stream: return Mapping.stream
        case .json: return Mapping.json
        case .urlEncoded: return Mapping.urlEncoded
        }
    }
}
