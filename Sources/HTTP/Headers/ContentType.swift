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
        // FIXME: validate
        let bytes = try stream.read(until: .cr)

        let semicolonIndex = bytes.index(of: .semicolon)

        self.mediaType = semicolonIndex == nil
            ? try MediaType(from: bytes)
            : try MediaType(from: bytes[..<semicolonIndex!])

        switch self.mediaType {
        case .multipart:
            guard let semicolonIndex = semicolonIndex,
                semicolonIndex < bytes.endIndex else {
                    throw HTTPError.invalidContentTypeHeader
            }
            let startIndex = semicolonIndex + 1
            self.charset = nil
            self.boundary = try Boundary(
                from: bytes[startIndex...].trimmingLeftSpace())

        default:
            guard let semicolonIndex = semicolonIndex else {
                self.charset = nil
                self.boundary = nil
                break
            }
            let startIndex = semicolonIndex + 1
            let charset = bytes[startIndex...].trimmingLeftSpace()
            guard charset.count > Bytes.charset.count else {
                throw HTTPError.invalidContentTypeHeader
            }
            let charsetValueIndex = charset.startIndex + Bytes.charset.count
            self.charset = try Charset(from: charset[charsetValueIndex...])
            self.boundary = nil
        }
    }

    func encode(to buffer: inout [UInt8]) {
        mediaType.encode(to: &buffer)
        if let charset = charset {
            charset.encode(to: &buffer)
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

    init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        let boundaryStart = bytes.startIndex + Bytes.boundary.count
        guard boundaryStart < bytes.endIndex else {
            throw HTTPError.invalidContentTypeHeader
        }
        self = try Boundary([UInt8](bytes[boundaryStart...]))
    }
}
