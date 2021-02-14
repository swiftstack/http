import Stream

extension Array where Element == Request.AcceptCharset {
    public typealias AcceptCharset = Request.AcceptCharset

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        var values = [AcceptCharset]()

        while true {
            let value = try await AcceptCharset.decode(from: stream)
            values.append(value)
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
            }
            try await self[i].encode(to: stream)
        }
    }
}

extension Request.AcceptCharset {
    private struct Bytes {
        static let qEqual = ASCII("q=")
    }

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        let charset = try await Charset.decode(from: stream)

        guard try await stream.consume(.semicolon) else {
            return .init(charset, priority: 1.0)
        }

        guard try await stream.consume(sequence: Bytes.qEqual) else {
            throw ParseError.invalidAcceptCharsetHeader
        }
        guard let priority = try await stream.parse(Double.self) else {
            throw ParseError.invalidAcceptCharsetHeader
        }
        return .init(charset, priority: priority)
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        try await charset.encode(to: stream)

        if priority < 1.0 {
            try await stream.write(.semicolon)
            try await stream.write(Bytes.qEqual)
            try await stream.write([UInt8](String(describing: priority)))
        }
    }
}
