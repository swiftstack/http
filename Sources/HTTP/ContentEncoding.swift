public enum ContentEncoding {
    case gzip
    case deflate
    case custom(String)
}

extension ContentEncoding: Equatable {
    public static func ==(lhs: ContentEncoding, rhs: ContentEncoding) -> Bool {
        switch (lhs, rhs) {
        case (.gzip, .gzip):
            return true
        case (.deflate, .deflate):
            return true
        case let (.custom(lhsValue), .custom(rhsValue))
            where lhsValue == rhsValue:
            return true
        default:
            return false
        }
    }
}

extension Array where Element == ContentEncoding {
    init(from bytes: UnsafeRawBufferPointer) throws {
        var startIndex = 0
        var endIndex = 0
        var values = [ContentEncoding]()
        while endIndex < bytes.endIndex {
            endIndex =
                bytes.index(of: Character.comma, offset: startIndex) ??
                bytes.endIndex
            let value = ContentEncoding(from: bytes[startIndex..<endIndex])
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

extension ContentEncoding {
    private struct Bytes {
        static let gzip = ASCII("gzip")
        static let deflate = ASCII("deflate")
    }

    init(from bytes: UnsafeRawBufferPointer) {
        switch bytes.lowercasedHashValue {
        case Bytes.gzip.lowercasedHashValue:
            self = .gzip
        case Bytes.deflate.lowercasedHashValue:
            self = .deflate
        default:
            self = .custom(String(buffer: bytes))
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .gzip:
            buffer.append(contentsOf: Bytes.gzip)
        case .deflate:
            buffer.append(contentsOf: Bytes.deflate)
        case .custom(let value):
            buffer.append(contentsOf: [UInt8](value))
        }
    }
}
