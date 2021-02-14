import Stream

extension Array where Element == Request.AcceptLanguage {
    public typealias AcceptLanguage = Request.AcceptLanguage

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        var values = [AcceptLanguage]()
        while true {
            let value = try await AcceptLanguage.decode(from: stream)
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

extension Request.AcceptLanguage {
    private struct Bytes {
        static let qEqual = ASCII("q=")
    }

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        let language = try await Language.decode(from: stream)

        guard try await stream.consume(.semicolon) else {
            return .init(language, priority: 1.0)
        }

        guard try await stream.consume(sequence: Bytes.qEqual) else {
            throw ParseError.invalidAcceptLanguageHeader
        }
        guard let priority = try await stream.parse(Double.self) else {
            throw ParseError.invalidAcceptLanguageHeader
        }
        return .init(language, priority: priority)
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        try await language.encode(to: stream)

        if priority < 1.0 {
            try await stream.write(.semicolon)
            try await stream.write(Bytes.qEqual)
            try await stream.write(String(describing: priority))
        }
    }
}
