import Stream

public enum ContentEncoding {
    case gzip
    case deflate
    case custom(String)
}

extension ContentEncoding: Equatable {
    public static func ==(lhs: ContentEncoding, rhs: ContentEncoding) -> Bool {
        switch (lhs, rhs) {
        case (.gzip, .gzip): return true
        case (.deflate, .deflate): return true
        case let (.custom(lhs), .custom(rhs)): return lhs == rhs
        default: return false
        }
    }
}

extension Array where Element == ContentEncoding {
    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        var values = [ContentEncoding]()
        while true {
            let contentEncoding = try ContentEncoding(from: stream)
            values.append(contentEncoding)
            guard try stream.consume(.comma) else {
                break
            }
            try stream.consume(while: { $0 == .whitespace })
        }
        self = values
    }

    func encode(to buffer: inout [UInt8]) {
        for i in startIndex..<endIndex {
            if i != startIndex {
                buffer.append(.comma)
                buffer.append(.whitespace)
            }
            self[i].encode(to: &buffer)
        }
    }
}

extension ContentEncoding {
    private struct Bytes {
        static let gzip = ASCII("gzip")
        static let deflate = ASCII("deflate")
    }

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        let bytes = try stream.read(allowedBytes: .token)
        switch bytes.lowercasedHashValue {
        case Bytes.gzip.lowercasedHashValue: self = .gzip
        case Bytes.deflate.lowercasedHashValue: self = .deflate
        default: self = .custom(String(decoding: bytes, as: UTF8.self))
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .gzip: buffer.append(contentsOf: Bytes.gzip)
        case .deflate: buffer.append(contentsOf: Bytes.deflate)
        case .custom(let value): buffer.append(contentsOf: value.utf8)
        }
    }
}
