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

    public init(json object: Encodable) throws {
        let encoder = JSONEncoder()
        let json = try encoder.encode(object)

        contentType = ContentType(mediaType: .application(.json))
        rawBody = [UInt8](json.utf8)
        contentLength = rawBody!.count
    }

    public init(urlEncoded query: URL.Query) {
        var urlEncodedBytes = [UInt8]()
        query.encode(to: &urlEncodedBytes)

        contentType = ContentType(mediaType: .application(.urlEncoded))
        rawBody = urlEncodedBytes
        contentLength = urlEncodedBytes.count
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
