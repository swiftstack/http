public struct ContentType {
    public var mediaType: MediaType
    public var charset: Charset?
    public var boundary: Boundary?
}

extension ContentType {
    public static let html = ContentType(mediaType: .text(.html))
    public static let text = ContentType(mediaType: .text(.plain))
    public static let json = ContentType(mediaType: .application(.json))
    public static let xml = ContentType(mediaType: .application(.xml))
    public static let formURLEncoded = ContentType(
        mediaType: .application(.formURLEncoded))
    public static let stream = ContentType(mediaType: .application(.stream))
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

public struct Boundary {
    public let bytes: [UInt8]

    public init(_ bytes: [UInt8]) throws {
        guard bytes.count >= 1 && bytes.count <= 70 else {
            throw ParseError.invalidBoundary
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
