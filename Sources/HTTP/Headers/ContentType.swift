import Stream

public struct ContentType {
    public var mediaType: MediaType
    public var charset: Charset?
    public var boundary: Boundary?
}

extension ContentType {
    public init?(mediaType: MediaType, charset: Charset? = nil) {
        if case .multipart = mediaType {
            return nil
        }
        self.mediaType = mediaType
        self.charset = charset
        self.boundary = nil
    }

    public init(multipart subtype: MultipartSubtype, boundary: Boundary) {
        self.mediaType = .multipart(subtype)
        self.boundary = boundary
        self.charset = nil
    }
}

extension ContentType: Equatable {
    public static func == (lhs: ContentType, rhs: ContentType) -> Bool {
        return lhs.mediaType == rhs.mediaType
            && lhs.charset == rhs.charset
            && lhs.boundary == rhs.boundary
    }
}

extension ContentType {
    private struct Bytes {
        static let charset = ASCII("charset=")
    }

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        self.mediaType = try MediaType(from: stream)

        switch self.mediaType {
        case .multipart:
            guard try stream.consume(.semicolon) else {
                throw HTTPError.invalidContentTypeHeader
            }
            try stream.consume(while: { $0 == .whitespace })

            self.charset = nil
            self.boundary = try Boundary(from: stream)

        default:
            guard try stream.consume(.semicolon) else {
                self.charset = nil
                self.boundary = nil
                break
            }
            try stream.consume(while: { $0 == .whitespace })

            // FIXME: validate with value-specific rule
            guard try stream.consume(sequence: Bytes.charset) else {
                throw HTTPError.invalidContentTypeHeader
            }
            self.charset = try Charset(from: stream)
            self.boundary = nil
        }
    }

    func encode<T: OutputStream>(to stream: BufferedOutputStream<T>) throws {
        try mediaType.encode(to: stream)
        if let charset = charset {
            try charset.encode(to: stream)
        }
    }
}

public struct Boundary {
    public let bytes: [UInt8]

    public init(_ bytes: [UInt8]) throws {
        guard bytes.count >= 1 && bytes.count <= 70 else {
            throw HTTPError.invalidBoundary
        }
        self.bytes = bytes
    }

    public init(_ string: String) throws {
        try self.init([UInt8](string.utf8))
    }
}

extension Boundary: Equatable {
    public static func == (lhs: Boundary, rhs: Boundary) -> Bool {
        return lhs.bytes == rhs.bytes
    }
}

extension Boundary {
    private struct Bytes {
        static let boundary = ASCII("boundary=")
    }

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        guard try stream.consume(sequence: Bytes.boundary) else {
            throw HTTPError.invalidBoundary
        }
        // FIXME: validate with value-specific rule
        let buffer = try stream.read(allowedBytes: .text)
        self = try Boundary([UInt8](buffer))
    }
}
