import JSON

public struct Response {
    public var status: Status = .ok
    public var version: Version = .oneOne

    public var connection: Connection? = nil
    public var contentEncoding: [ContentEncoding]? = nil
    public var contentType: ContentType? = nil
    public var contentLength: Int? = nil
    public var transferEncoding: [TransferEncoding]? = nil

    public var headers: [HeaderName : String] = [:]

    public var setCookie: [SetCookie] = []

    public var rawBody: [UInt8]? = nil {
        didSet {
            contentLength = rawBody?.count
        }
    }

    public init() {
        self.contentLength = 0
    }
}

extension Response {
    public var body: String? {
        guard let rawBody = rawBody else {
            return nil
        }
        return String(bytes: rawBody, encoding: .utf8)
    }
}

extension Response {
    public init(status: Status) {
        self.status = status
        self.contentLength = 0
    }

    public init(version: Version) {
        self.version = version
        self.contentLength = 0
    }

    public init(string: String) {
        contentType = ContentType(mediaType: .text(.plain))
        rawBody = [UInt8](string.utf8)
        contentLength = rawBody!.count
    }

    public init(html: String) {
        contentType = ContentType(mediaType: .text(.html))
        rawBody = [UInt8](html.utf8)
        contentLength = rawBody!.count
    }

    public init(bytes: [UInt8]) {
        contentType = ContentType(mediaType: .application(.stream))
        rawBody = bytes
        contentLength = bytes.count
    }
}

extension Response {
    public init(
        body object: Encodable,
        contentType type: ApplicationSubtype = .json
    ) throws {
        var response = Response()

        switch type {
        case .json:
            response.contentType = ContentType(
                mediaType: .application(.json))
            let encoder = JSONEncoder()
            response.rawBody = try encoder.encode(object)

        case .urlEncoded:
            response.contentType = ContentType(
                mediaType: .application(.urlEncoded))
            response.rawBody = try URLFormEncoded.encode(encodable: object)

        default:
            throw HTTPError.unsupportedContentType
        }

        self = response
    }
}
