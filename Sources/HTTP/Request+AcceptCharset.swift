public enum Charset {
    case isoLatin1
    case utf8
    case any
    case custom(String)
}

public struct AcceptCharset {
    public let charset: Charset
    public let priority: Double

    public init(_ charset: Charset, priority: Double = 1.0) {
        self.charset = charset
        self.priority = priority
    }
}

extension AcceptCharset: Equatable {
    public static func ==(lhs: AcceptCharset, rhs: AcceptCharset) -> Bool {
        switch (lhs.charset, rhs.charset) {
        case (.utf8, .utf8) where lhs.priority == rhs.priority:
            return true
        case (.isoLatin1, .isoLatin1) where lhs.priority == rhs.priority:
            return true
        case (.any, .any) where lhs.priority == rhs.priority:
            return true
        case let (.custom(lhsValue), .custom(rhsValue))
            where lhsValue == rhsValue && lhs.priority == rhs.priority:
            return true
        default:
            return false
        }
    }
}

extension Array where Element == AcceptCharset {
    init(from bytes: UnsafeRawBufferPointer) throws {
        var startIndex = 0
        var endIndex = 0
        var values = [AcceptCharset]()
        while endIndex < bytes.endIndex {
            endIndex =
                bytes.index(of: Character.comma, offset: startIndex) ??
                bytes.endIndex
            values.append(try AcceptCharset(from: bytes[startIndex..<endIndex]))
            startIndex = endIndex.advanced(by: 1)
            if startIndex < bytes.endIndex &&
                bytes[startIndex] == Character.whitespace {
                    startIndex += 1
            }
        }
        self = values
    }

    var bytes: [UInt8] {
        var bytes = [UInt8]()
        encode(to: &bytes)
        return bytes
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

extension AcceptCharset {
    struct Bytes {
        static let isoLatin1 = ASCII("ISO-8859-1")
        static let utf8 = ASCII("utf-8")
        static let any = ASCII("*")

        static let qEqual = ASCII("q=")
    }

    init(from bytes: UnsafeRawBufferPointer) throws {
        let semicolonIndex = bytes.index(of: Character.semicolon, offset: 0)

        let charsetEndIndex = semicolonIndex ?? bytes.endIndex
        let charsetBytes = bytes.prefix(upTo: charsetEndIndex)

        if charsetBytes.elementsEqual(Bytes.utf8) {
            self.charset = .utf8
        } else if charsetBytes.elementsEqual(Bytes.isoLatin1) {
            self.charset = .isoLatin1
        } else if charsetBytes.elementsEqual(Bytes.any) {
            self.charset = .any
        } else {
            self.charset = .custom(String(buffer: charsetBytes))
        }

        if let semicolonIndex = semicolonIndex {
            let priorityBytes = bytes.suffix(
                from: semicolonIndex.advanced(by: 1))
            guard priorityBytes.count == 5,
                priorityBytes.starts(with: Bytes.qEqual),
                let priority = Double(
                    String(buffer: priorityBytes.suffix(from: 2))) else {
                        throw HTTPError.invalidHeaderValue
            }
            self.priority = priority
        } else {
            self.priority = 1.0
        }
    }

    func encode(to buffer: inout [UInt8]) {
        switch self.charset {
        case .utf8:
            buffer.append(contentsOf: Bytes.utf8)
        case .isoLatin1:
            buffer.append(contentsOf: Bytes.isoLatin1)
        case .any:
            buffer.append(contentsOf: Bytes.any)
        case .custom(let value):
            buffer.append(contentsOf: [UInt8](value))
        }

        if priority < 1.0 {
            buffer.append(Character.semicolon)
            buffer.append(contentsOf: Bytes.qEqual)
            buffer.append(contentsOf: [UInt8](String(describing: priority)))
        }
    }
}
