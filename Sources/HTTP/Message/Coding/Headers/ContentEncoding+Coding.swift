import Stream

extension Array where Element == ContentEncoding {
    init<T: StreamReader>(from stream: T) throws {
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

    func encode<T: StreamWriter>(to stream: T) throws {
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

    init<T: StreamReader>(from stream: T) throws {
        self = try stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.gzip.lowercasedHashValue: return .gzip
            case Bytes.deflate.lowercasedHashValue: return .deflate
            default: return .custom(String(decoding: bytes, as: UTF8.self))
            }
        }
    }

    func encode<T: StreamWriter>(to stream: T) throws {
        let bytes: [UInt8]
        switch self {
        case .gzip: bytes = Bytes.gzip
        case .deflate: bytes = Bytes.deflate
        case .custom(let value): bytes = [UInt8](value.utf8)
        }
        try stream.write(bytes)
    }
}
