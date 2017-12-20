import JSON
import KeyValueCodable

public struct Request {
    public var method: Method
    public var url: URL
    public var version: Version

    public var host: URL.Host? {
        get {
            return url.host
        }
        set {
            url.host = newValue
        }
    }

    public var userAgent: String? = nil
    public var accept: [Accept]? = nil
    public var acceptLanguage: [AcceptLanguage]? = nil
    public var acceptEncoding: [ContentEncoding]? = nil
    public var acceptCharset: [AcceptCharset]? = nil
    public var authorization: Authorization? = nil
    public var keepAlive: Int? = nil
    public var connection: Connection? = nil
    public var contentType: ContentType? = nil
    public var contentLength: Int? = nil
    public var transferEncoding: [TransferEncoding]? = nil

    public var headers: [HeaderName : String] = [:]

    public var cookies: [Cookie] = []

    public var rawBody: [UInt8]? = nil {
        didSet {
            contentLength = rawBody?.count
        }
    }
}

extension Request {
    public var shouldKeepAlive: Bool {
        if self.connection == .close {
            return false
        }
        return true
    }

    public var body: String? {
        guard let rawBody = rawBody else {
            return nil
        }
        return String(bytes: rawBody, encoding: .utf8)
    }

    public init(method: Method = .get, url: URL = URL(path: "/")) {
        self.method = method
        self.url = url
        self.version = .oneOne
        self.host = host

        if method == .post || method == .put, let query = url.query {
            let bytes = query.encode()
            self.rawBody = bytes
            self.contentLength = bytes.count
            self.contentType = ContentType(mediaType: .application(.urlEncoded))
        }
    }
}

extension Request {
    public init<T: Encodable>(
        method: Method,
        url: URL,
        body: T,
        contentType type: ApplicationSubtype = .json
    ) throws {
        var request = Request(method: .post, url: url)

        switch type {
        case .json:
            request.contentType = ContentType(
                mediaType: .application(.json))
            request.rawBody = try JSON.encode(body)

        case .urlEncoded:
            request.contentType = ContentType(
                mediaType: .application(.urlEncoded))
            request.rawBody = try URLFormEncoded.encode(body)

        default:
            throw HTTPError.unsupportedContentType
        }

        self = request
    }
}
