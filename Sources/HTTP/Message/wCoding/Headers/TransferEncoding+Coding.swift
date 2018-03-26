import Stream

extension Array where Element == TransferEncoding {
    init<T: StreamReader>(from stream: T) throws {
        // FIXME: validate
        self = try stream.read(until: .cr) { bytes in
            var startIndex = bytes.startIndex
            var endIndex = startIndex
            var values = [TransferEncoding]()
            while endIndex < bytes.endIndex {
                endIndex =
                    bytes[startIndex...].index(of: .comma) ??
                    bytes.endIndex
                let value = try TransferEncoding(from: bytes[startIndex..<endIndex])
                values.append(value)
                startIndex = endIndex.advanced(by: 1)
                if startIndex < bytes.endIndex &&
                    bytes[startIndex] == .whitespace {
                    startIndex += 1
                }
            }
            return values
        }
    }

    func encode<T: StreamWriter>(to stream: T) throws {
        for i in startIndex..<endIndex {
            if i != startIndex {
                try stream.write(.comma)
            }
            try self[i].encode(to: stream)
        }
    }
}

extension TransferEncoding {
    private struct Bytes {
        static let chunked = ASCII("chunked")
        static let compress = ASCII("compress")
        static let deflate = ASCII("deflate")
        static let gzip = ASCII("gzip")
        static let identity = ASCII("identity")
    }

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        switch bytes.lowercasedHashValue {
        case Bytes.chunked.lowercasedHashValue: self = .chunked
        case Bytes.compress.lowercasedHashValue: self = .compress
        case Bytes.deflate.lowercasedHashValue: self = .deflate
        case Bytes.gzip.lowercasedHashValue: self = .gzip
        case Bytes.identity.lowercasedHashValue: self = .identity
        default: throw ParseError.invalidTransferEncodingHeader
        }
    }

    func encode<T: StreamWriter>(to stream: T) throws {
        let bytes: [UInt8]
        switch self {
        case .chunked: bytes = Bytes.chunked
        case .compress: bytes = Bytes.compress
        case .deflate: bytes = Bytes.deflate
        case .gzip: bytes = Bytes.gzip
        case .identity: bytes = Bytes.identity
        }
        try stream.write(bytes)
    }
}
