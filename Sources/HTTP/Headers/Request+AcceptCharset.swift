import Stream

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

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        var values = [AcceptCharset]()

        while true {
            let value = try AcceptCharset(from: stream)
            values.append(value)
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
            }
            self[i].encode(to: &buffer)
        }
    }
}

extension Request.AcceptCharset {
    private struct Bytes {
        static let qEqual = ASCII("q=")
    }

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        self.charset = try Charset(from: stream)

        guard try stream.consume(.semicolon) else {
            self.priority = 1.0
            return
        }

        guard try stream.consume(sequence: Bytes.qEqual) else {
            throw HTTPError.invalidAcceptCharsetHeader
        }
        // FIXME: implement Double(from stream:)
        let buffer = try stream.read(allowedBytes: .token)
        guard let priority = Double(from: buffer) else {
            throw HTTPError.invalidAcceptCharsetHeader
        }
        self.priority = priority
    }

    func encode(to buffer: inout [UInt8]) {
        charset.encode(to: &buffer)

        if priority < 1.0 {
            buffer.append(.semicolon)
            buffer.append(contentsOf: Bytes.qEqual)
            buffer.append(contentsOf: [UInt8](String(describing: priority)))
        }
    }
}
