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
    init<T: UnsafeStreamReader>(from stream: T) throws {
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

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        for i in startIndex..<endIndex {
            if i != startIndex {
                try stream.write(.comma)
                try stream.write(.whitespace)
            }
            try self[i].encode(to: stream)
        }
    }
}

extension ContentEncoding {
    private struct Bytes {
        static let gzip = ASCII("gzip")
        static let deflate = ASCII("deflate")
    }

    init<T: UnsafeStreamReader>(from stream: T) throws {
        let bytes = try stream.read(allowedBytes: .token)
        switch bytes.lowercasedHashValue {
        case Bytes.gzip.lowercasedHashValue: self = .gzip
        case Bytes.deflate.lowercasedHashValue: self = .deflate
        default: self = .custom(String(decoding: bytes, as: UTF8.self))
        }
    }

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        let bytes: [UInt8]
        switch self {
        case .gzip: bytes = Bytes.gzip
        case .deflate: bytes = Bytes.deflate
        case .custom(let value): bytes = [UInt8](value.utf8)
        }
        try stream.write(bytes)
    }
}
