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
    public var userAgent: String? = nil
    public var accept: [Accept]? = nil
    public var acceptLanguage: [AcceptLanguage]? = nil
    public var acceptEncoding: [ContentEncoding]? = nil
    public var acceptCharset: [AcceptCharset]? = nil
    public var authorization: Authorization? = nil
    public var keepAlive: Int? = nil
    public var connection: Connection? = nil
    public var contentType: ContentType? = nil
    public var contentEncoding: [ContentEncoding]? = nil
    public var contentLength: Int? = nil
    public var transferEncoding: [TransferEncoding]? = nil

    public var headers: [HeaderName : String] = [:]

    public var cookies: [Cookie] = []

    public var expect: Expect? = nil

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

        switch type {
        case .json:
            let bytes = try JSON.encode(body)
            self.contentType = .json
            self.body = .output(bytes)
            self.contentLength = bytes.count

        case .formURLEncoded:
            let bytes = try FormURLEncoded.encode(body)
            self.contentType = .formURLEncoded
            self.body = .output(bytes)
            self.contentLength = bytes.count

        default:
            throw Error.unsupportedContentType
        }
    }
}
