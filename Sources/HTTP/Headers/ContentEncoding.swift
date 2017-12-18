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
    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        var startIndex = bytes.startIndex
        var endIndex = startIndex
        var values = [ContentEncoding]()
        while endIndex < bytes.endIndex {
            endIndex =
                bytes[startIndex...].index(of: .comma) ??
                bytes.endIndex
            let value = try ContentEncoding(from: bytes[startIndex..<endIndex])
            values.append(value)
            startIndex = endIndex.advanced(by: 1)
            if startIndex < bytes.endIndex &&
                bytes[startIndex] == .whitespace {
                    startIndex += 1
            }
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

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        switch bytes.lowercasedHashValue {
        case Bytes.gzip.lowercasedHashValue: self = .gzip
        case Bytes.deflate.lowercasedHashValue: self = .deflate
        default:
            guard let encoding = String(validating: bytes, as: .token) else {
                throw HTTPError.invalidContentEncoding
            }
            self = .custom(encoding)
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
