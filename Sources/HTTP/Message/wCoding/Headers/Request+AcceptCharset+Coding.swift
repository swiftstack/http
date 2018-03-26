import Stream

extension Array where Element == Request.AcceptCharset {
    public typealias AcceptCharset = Request.AcceptCharset

    init<T: StreamReader>(from stream: T) throws {
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

    func encode<T: StreamWriter>(to stream: T) throws {
        for i in startIndex..<endIndex {
            if i != startIndex {
                try stream.write(.comma)
            }
            try self[i].encode(to: stream)
        }
    }
}

extension Request.AcceptCharset {
    private struct Bytes {
        static let qEqual = ASCII("q=")
    }

    init<T: StreamReader>(from stream: T) throws {
        self.charset = try Charset(from: stream)

        guard try stream.consume(.semicolon) else {
            self.priority = 1.0
            return
        }

        guard try stream.consume(sequence: Bytes.qEqual) else {
            throw ParseError.invalidAcceptCharsetHeader
        }
        guard let priority = try Double(from: stream) else {
            throw ParseError.invalidAcceptCharsetHeader
        }
        self.priority = priority
    }

    func encode<T: StreamWriter>(to stream: T) throws {
        try charset.encode(to: stream)

        if priority < 1.0 {
            try stream.write(.semicolon)
            try stream.write(Bytes.qEqual)
            try stream.write([UInt8](String(describing: priority)))
        }
    }
}
