public struct ContentType: Equatable {
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

public struct Boundary: Equatable {
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

// MARK: Convenience

extension ContentType {
    public static let html = ContentType(
        mediaType: .text(.html))!

    public static let css = ContentType(
        mediaType: .text(.css))!

    public static let text = ContentType(
        mediaType: .text(.plain))!

    public static let jpeg = ContentType(
        mediaType: .image(.jpeg))!

    public static let png = ContentType(
        mediaType: .image(.png))!

    public static let gif = ContentType(
        mediaType: .image(.gif))!

    public static let json = ContentType(
        mediaType: .application(.json))!

    public static let xml = ContentType(
        mediaType: .application(.xml))!

    public static let javascript = ContentType(
        mediaType: .application(.javascript))!

    public static let formURLEncoded = ContentType(
        mediaType: .application(.formURLEncoded))!

    public static let stream = ContentType(
        mediaType: .application(.stream))!
}
