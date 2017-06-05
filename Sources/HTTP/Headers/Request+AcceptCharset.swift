extension Request {
    public struct AcceptCharset {
        public let charset: Charset
        public let priority: Double

        public init(_ charset: Charset, priority: Double = 1.0) {
            self.charset = charset
            self.priority = priority
        }
    }
}

extension Request.AcceptCharset: Equatable {
    public typealias AcceptCharset = Request.AcceptCharset
    public static func ==(lhs: AcceptCharset, rhs: AcceptCharset) -> Bool {
        guard lhs.priority == rhs.priority else {
            return false
        }
        switch (lhs.charset, rhs.charset) {
        case (.utf8, .utf8): return true
        case (.isoLatin1, .isoLatin1): return true
        case (.any, .any): return true
        case let (.custom(lhs), .custom(rhs)): return lhs == rhs
        default: return false
        }
    }
}

extension Array where Element == Request.AcceptCharset {
    public typealias AcceptCharset = Request.AcceptCharset

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        var startIndex = bytes.startIndex
        var endIndex = startIndex
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

    func encode(to buffer: inout [UInt8]) {
        for i in startIndex..<endIndex {
            if i != startIndex {
                buffer.append(Character.comma)
            }
            self[i].encode(to: &buffer)
        }
    }
}

extension Request.AcceptCharset {
    private struct Bytes {
        static let qEqual = ASCII("q=")
    }

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        if let semicolon = bytes.index(of: Character.semicolon) {
            self.charset = try Charset(from: bytes[..<semicolon])

            let index = semicolon.advanced(by: 1)
            let bytes = UnsafeRawBufferPointer(rebasing: bytes[index...])
            guard bytes.count == 5,
                bytes.starts(with: Bytes.qEqual),
                let priority = Double(from: bytes[2...]) else {
                    throw HTTPError.invalidHeaderValue
            }
            self.priority = priority
        } else {
            self.charset = try Charset(from: bytes)
            self.priority = 1.0
        }
    }

    func encode(to buffer: inout [UInt8]) {
        charset.encode(to: &buffer)

        if priority < 1.0 {
            buffer.append(Character.semicolon)
            buffer.append(contentsOf: Bytes.qEqual)
            buffer.append(contentsOf: [UInt8](String(describing: priority)))
        }
    }
}
