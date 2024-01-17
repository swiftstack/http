import URL
import JSON
import Stream

public final class Request {
    public var method: Method
    public var url: URL
    public var version: Version

    public var host: URL.Host? {
        get { return url.host }
        set { url.host = newValue }
    }
    public var userAgent: String?
    public var accept: [Accept]?
    public var acceptLanguage: [AcceptLanguage]?
    public var acceptEncoding: [ContentEncoding]?
    public var acceptCharset: [AcceptCharset]?
    public var authorization: Authorization?
    public var keepAlive: Int?
    public var connection: Connection?
    public var contentType: ContentType?
    public var contentEncoding: [ContentEncoding]?
    public var contentLength: Int?
    public var transferEncoding: [TransferEncoding]?

    public var headers: [HeaderName: String] = [:]

    public var cookies: [Cookie] = []

    public var expect: Expect?

    public var body: Body = .output([])

    public init(url: URL = URL(path: "/"), method: Method = .get) {
        self.url = url
        self.method = method
        self.version = .oneOne
        self.host = url.host

        if method == .post || method == .put, let query = url.query {
            let bytes = query.encode()
            self.body = .output(bytes)
            self.contentLength = bytes.count
            self.contentType = .formURLEncoded
        }
    }
}

extension Request {
    public var shouldKeepAlive: Bool {
        return self.connection != .close
    }
}

// MARK: Convenience

extension Request {
    public convenience init<T: Encodable>(
        url: URL,
        method: Method,
        body: T,
        contentType type: ApplicationSubtype = .json
    ) throws {
        self.init(url: url, method: method)
        try Coder.encode(object: body, to: self, contentType: type)
    }
}
