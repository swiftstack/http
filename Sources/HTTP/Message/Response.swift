import JSON

public class Response {
    public var status: Status = .ok
    public var version: Version = .oneOne

    public var connection: Connection? = nil
    public var contentEncoding: [ContentEncoding]? = nil
    public var contentType: ContentType? = nil
    public var contentLength: Int? = nil
    public var transferEncoding: [TransferEncoding]? = nil
    public var setCookie: [SetCookie] = []

    public var headers: [HeaderName : String] = [:]

    public var body: Body = .none

    public init() {
        self.contentLength = 0
    }
}

extension Response: BodyInpuStream {}

extension Response {
    public convenience init(status: Status) {
        self.init()
        self.status = status
    }

    public convenience init(version: Version) {
        self.init()
        self.version = version
    }

    public convenience init(string: String) {
        self.init()
        self.contentType = .text
        self.bytes = [UInt8](string.utf8)
        self.contentLength = bytes!.count
    }

    public convenience init(html: String) {
        self.init()
        self.contentType = .html
        self.bytes = [UInt8](html.utf8)
        self.contentLength = bytes!.count
    }

    public convenience init(bytes: [UInt8]) {
        self.init()
        self.contentType = .stream
        self.bytes = bytes
        self.contentLength = bytes.count
    }
}

extension Response {
    public convenience init(
        body object: Encodable,
        contentType type: ApplicationSubtype = .json
    ) throws {
        self.init()
        switch type {
        case .json:
            let bytes = try JSONEncoder().encode(object)
            self.bytes = bytes
            self.contentLength = bytes.count
            self.contentType = .json

        case .formURLEncoded:
            let bytes = try FormURLEncoded.encode(encodable: object)
            self.bytes = bytes
            self.contentLength = bytes.count
            self.contentType = .formURLEncoded

        default:
            throw ParseError.unsupportedContentType
        }
    }
}