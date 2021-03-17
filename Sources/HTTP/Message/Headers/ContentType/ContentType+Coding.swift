import Stream

extension ContentType {
    private struct Bytes {
        static let charset = ASCII("charset=")
    }

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        let mediaType = try await MediaType.decode(from: stream)

        switch mediaType {
        case .multipart(let subtype):
            guard try await stream.consume(.semicolon) else {
                throw Error.invalidContentTypeHeader
            }
            try await stream.consume(while: { $0 == .whitespace })

            let boundary = try await Boundary.decode(from: stream)
            return .init(multipart: subtype, boundary: boundary)

        default:
            guard try await stream.consume(.semicolon) else {
                return .init(mediaType: mediaType)!
            }
            try await stream.consume(while: { $0 == .whitespace })

            // FIXME: validate with value-specific rule
            guard try await stream.consume(sequence: Bytes.charset) else {
                throw Error.invalidContentTypeHeader
            }
            let charset = try await Charset.decode(from: stream)
            return .init(mediaType: mediaType, charset: charset)!
        }
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        try await mediaType.encode(to: stream)
        // FIXME: [Concurrency] build crash
        try await _encodeCharset(to: stream)

    }

    private func _encodeCharset<T: StreamWriter>(to stream: T) async throws {
        if let charset = charset {
            try await charset.encode(to: stream)
        }
    }
}

extension Boundary {
    private struct Bytes {
        static let boundary = ASCII("boundary=")
    }

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        guard try await stream.consume(sequence: Bytes.boundary) else {
            throw Error.invalidBoundary
        }
        // FIXME: validate with value-specific rule
        return try Boundary(try await stream.read(allowedBytes: .text))
    }
}
