public enum ContentType {
    case text
    case html
    case stream
    case json
    case urlEncoded
}

extension ContentType {
    private struct Bytes {
        static let text = ASCII("text/plain")
        static let html = ASCII("text/html")
        static let stream = ASCII("application/stream")
        static let json = ASCII("application/json")
        static let urlEncoded = ASCII("application/x-www-form-urlencoded")
    }

    init(from bytes: UnsafeRawBufferPointer) throws {
        switch bytes.lowercasedHashValue {
        case Bytes.text.lowercasedHashValue: self = .text
        case Bytes.html.lowercasedHashValue: self = .html
        case Bytes.stream.lowercasedHashValue: self = .stream
        case Bytes.json.lowercasedHashValue: self = .json
        case Bytes.urlEncoded.lowercasedHashValue: self = .urlEncoded
        default: throw HTTPError.unsupportedContentType
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .text: buffer.append(contentsOf: Bytes.text)
        case .html: buffer.append(contentsOf: Bytes.html)
        case .stream: buffer.append(contentsOf: Bytes.stream)
        case .json: buffer.append(contentsOf: Bytes.json)
        case .urlEncoded: buffer.append(contentsOf: Bytes.urlEncoded)
        }
    }
}
