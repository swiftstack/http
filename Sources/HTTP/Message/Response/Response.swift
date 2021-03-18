import JSON

public final class Response {
    public var status: Status = .ok
    public var version: Version = .oneOne

    public var connection: Connection? = nil
    public var contentEncoding: [ContentEncoding]? = nil
    public var contentType: ContentType? = nil
    public var contentLength: Int? = nil
    public var transferEncoding: [TransferEncoding]? = nil
    public var cookies: [SetCookie] = []

    public var headers: [HeaderName : String] = [:]

    public var body: Body = .output([])

    public init() {
        self.contentLength = 0
    }
}

extension Response {
    public convenience init(status: Status) {
        self.init()
        self.status = status
    }

    public convenience init(
        status: Status = .ok,
        bytes: [UInt8],
        contentType: ContentType = .stream)
    {
        self.init()
        self.body = .output(bytes)
        self.contentType = contentType
        self.contentLength = bytes.count
    }

    public convenience init(
        status: Status = .ok,
        string: String,
        contentType: ContentType = .text)
    {
        self.init(
            status: status,
            bytes: [UInt8](string.utf8),
            contentType: contentType)
    }

    public convenience init(status: Status = .ok, xml: String) {
        self.init(
            status: status,
            bytes: [UInt8](xml.utf8),
            contentType: .xml)
    }

    public convenience init(status: Status = .ok, html: String) {
        self.init(
            status: status,
            bytes: [UInt8](html.utf8),
            contentType: .html)
    }

    public convenience init(status: Status = .ok, javascript: String) {
        self.init(
            status: status,
            bytes: [UInt8](javascript.utf8),
            contentType: .javascript)
    }
}

extension Response {
    public convenience init(
        status: Status = .ok,
        body object: Encodable,
        contentType type: ApplicationSubtype = .json
    ) throws {
        self.init(status: status)
        try Coder.encode(object: object, to: self, contentType: type)
    }
}
