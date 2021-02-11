import Stream

extension Array where Element == ContentEncoding {
    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        var values = [ContentEncoding]()
        while true {
            let contentEncoding = try await ContentEncoding.decode(from: stream)
            values.append(contentEncoding)
            guard try await stream.consume(.comma) else {
                break
            }
            try await stream.consume(while: { $0 == .whitespace })
        }
        return values
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        for i in startIndex..<endIndex {
            if i != startIndex {
                try await stream.write(.comma)
                try await stream.write(.whitespace)
            }
            try await self[i].encode(to: stream)
        }
    }
}

extension ContentEncoding {
    private struct Bytes {
        static let gzip = ASCII("gzip")
        static let deflate = ASCII("deflate")
    }

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        return try await stream.read(allowedBytes: .token) { bytes in
            switch bytes.lowercasedHashValue {
            case Bytes.gzip.lowercasedHashValue: return .gzip
            case Bytes.deflate.lowercasedHashValue: return .deflate
            default: return .custom(String(decoding: bytes, as: UTF8.self))
            }
        }
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        let bytes: [UInt8]
        switch self {
        case .gzip: bytes = Bytes.gzip
        case .deflate: bytes = Bytes.deflate
        case .custom(let value): bytes = [UInt8](value.utf8)
        }
        try await stream.write(bytes)
    }
}
