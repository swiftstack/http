import JSON
import KeyValueCodable

public struct Request {
    public var method: Method
    public var url: URL
    public var version: Version

    public var host: String? = nil
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

        if var host = url.host {
            if let port = url.port {
                host.append(":\(port)")
            }
            self.host = host
        }

        if method == .post || method == .put, let query = url.query {
            var bytes = [UInt8]()
            query.encode(to: &bytes)
            self.rawBody = bytes
            self.contentLength = bytes.count
            self.contentType = ContentType(mediaType: .application(.urlEncoded))
        }
    }
}

extension Request {
    public init<T: Encodable>(method: Method, url: URL, json object: T) throws {
        let json = try JSON.encode(object)
        self.init(method: method, url: url)
        self.contentType = ContentType(mediaType: .application(.json))
        self.rawBody = json
        self.contentLength = json.count
    }

    public init<T: Encodable>(
        method: Method,
        url: URL,
        urlEncoded object: T
    ) throws {
        let values = try KeyValueEncoder().encode(object)
        let query = URL.Query(values: values)
        var urlEncodedBytes = [UInt8]()
        query.encode(to: &urlEncodedBytes)

        self.init(method: method, url: url)
        self.contentType = ContentType(mediaType: .application(.urlEncoded))
        self.rawBody = urlEncodedBytes
        self.contentLength = urlEncodedBytes.count
    }
}
