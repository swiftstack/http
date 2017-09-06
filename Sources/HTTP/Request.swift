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
    }
}

extension Request {
    public init<T: Encodable>(method: Method, url: URL, json object: T) throws {
        let json = try JSON.encode(object)
        let bytes = [UInt8](json.utf8)
        self.init(method: method, url: url)
        self.contentType = ContentType(mediaType: .application(.json))
        self.rawBody = bytes
        self.contentLength = bytes.count
    }

    public init<T: Encodable>(
        method: Method,
        url: URL,
        urlEncoded object: T
    ) throws {
        let values = try KeyValueEncoder().encode(object)
        let query = URL.Query(values)
        var urlEncodedBytes = [UInt8]()
        query.encode(to: &urlEncodedBytes)

        self.init(method: method, url: url)
        self.contentType = ContentType(mediaType: .application(.urlEncoded))
        self.rawBody = urlEncodedBytes
        self.contentLength = urlEncodedBytes.count
    }
}

extension Request {
    public var bytes: [UInt8] {
        var bytes = [UInt8]()
        encode(to: &bytes)
        return bytes
    }

    func encode(to buffer: inout [UInt8]) {
        // Start Line
        method.encode(to: &buffer)
        buffer.append(Character.whitespace)
        url.encode(to: &buffer)
        buffer.append(Character.whitespace)
        version.encode(to: &buffer)
        buffer.append(contentsOf: Constants.lineEnd)

        // Headers
        @inline(__always)
        func writeHeader(_ name: HeaderName, encoder: (inout [UInt8]) -> Void) {
            buffer.append(contentsOf: name.bytes)
            buffer.append(Character.colon)
            buffer.append(Character.whitespace)
            encoder(&buffer)
            buffer.append(contentsOf: Constants.lineEnd)
        }

        @inline(__always)
        func writeHeader(_ name: HeaderName, value: String) {
            buffer.append(contentsOf: name.bytes)
            buffer.append(Character.colon)
            buffer.append(Character.whitespace)
            buffer.append(contentsOf: value.utf8)
            buffer.append(contentsOf: Constants.lineEnd)
        }

        if let host = self.host {
            writeHeader(.host, value: host)
        }

        if let contentType = self.contentType {
            writeHeader(.contentType, encoder: contentType.encode)
        }

        if let contentLength = self.contentLength {
            writeHeader(.contentLength, value: String(contentLength))
        }

        if let userAgent = self.userAgent {
            writeHeader(.userAgent, value: userAgent)
        }

        if let accept = self.accept {
            writeHeader(.accept, encoder: accept.encode)
        }

        if let acceptLanguage = self.acceptLanguage {
            writeHeader(.acceptLanguage, encoder: acceptLanguage.encode)
        }

        if let acceptEncoding = self.acceptEncoding {
            writeHeader(.acceptEncoding, encoder: acceptEncoding.encode)
        }

        if let acceptCharset = self.acceptCharset {
            writeHeader(.acceptCharset, encoder: acceptCharset.encode)
        }

        if let authorization = self.authorization {
            writeHeader(.authorization, encoder: authorization.encode)
        }

        if let keepAlive = self.keepAlive {
            writeHeader(.keepAlive, value: String(keepAlive))
        }

        if let connection = self.connection {
            writeHeader(.connection, encoder: connection.encode)
        }

        if let transferEncoding = self.transferEncoding {
            writeHeader(.transferEncoding, encoder: transferEncoding.encode)
        }

        for (key, value) in headers {
            writeHeader(key, value: value)
        }

        // Cookies
        for cookie in cookies {
            writeHeader(.cookie, encoder: cookie.encode)
        }

        // Separator
        buffer.append(contentsOf: Constants.lineEnd)

        // Body
        if let rawBody = rawBody {
            buffer.append(contentsOf: rawBody)
        }
    }
}
