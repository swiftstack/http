public enum TransferEncoding {
    case chunked
    case compress
    case deflate
    case gzip
    case identity
}

extension TransferEncoding: Equatable {
    public static func ==(
        lhs: TransferEncoding,
        rhs: TransferEncoding
    ) -> Bool {
        switch (lhs, rhs) {
        case (.chunked, .chunked): return true
        case (.compress, .compress): return true
        case (.deflate, .deflate): return true
        case (.gzip, .gzip): return true
        case (.identity, .identity): return true
        default: return false
        }
    }
}

extension Array where Element == TransferEncoding {
    init(from bytes: UnsafeRawBufferPointer) throws {
        var startIndex = 0
        var endIndex = 0
        var values = [TransferEncoding]()
        while endIndex < bytes.endIndex {
            endIndex =
                bytes.index(of: Character.comma, offset: startIndex) ??
                bytes.endIndex
            let value = try TransferEncoding(from: bytes[startIndex..<endIndex])
            values.append(value)
            startIndex = endIndex.advanced(by: 1)
            if startIndex < bytes.endIndex &&
                bytes[startIndex] == Character.whitespace {
                    startIndex += 1
            }
        }
        self = values
    }

    func encode(to buffer: inout [UInt8]) {
        for i in startIndex..<endIndex {
            if i != startIndex {
                buffer.append(Character.comma)
            }
            self[i].encode(to: &buffer)
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

    init(from bytes: UnsafeRawBufferPointer) throws {
        switch bytes.lowercasedHashValue {
        case Bytes.chunked.lowercasedHashValue: self = .chunked
        case Bytes.compress.lowercasedHashValue: self = .compress
        case Bytes.deflate.lowercasedHashValue: self = .deflate
        case Bytes.gzip.lowercasedHashValue: self = .gzip
        case Bytes.identity.lowercasedHashValue: self = .identity
        default: throw HTTPError.invalidHeaderValue
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .chunked: buffer.append(contentsOf: Bytes.chunked)
        case .compress: buffer.append(contentsOf: Bytes.compress)
        case .deflate: buffer.append(contentsOf: Bytes.deflate)
        case .gzip: buffer.append(contentsOf: Bytes.gzip)
        case .identity: buffer.append(contentsOf: Bytes.identity)
        }
    }
}
