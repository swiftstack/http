import JSON
import Stream
import KeyValueCodable

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
    public var contentLength: Int? = nil
    public var transferEncoding: [TransferEncoding]? = nil

    public var headers: [HeaderName : String] = [:]

    public var cookies: [Cookie] = []

    public var expect: Expect? = nil

    internal var body: Body = .none

    public init(method: Method = .get, url: URL = URL(path: "/")) {
        self.method = method
        self.url = url
        self.version = .oneOne
        self.host = url.host

        if method == .post || method == .put, let query = url.query {
            let bytes = query.encode()
            self.body = .bytes(bytes)
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

// MARK: Body Streams

extension Request {
    var inputStream: UnsafeStreamReader? {
        get {
            guard case .input(let reader) = body else {
                return nil
            }
            return reader
        }
        set {
            switch newValue {
            case .none: self.body = .none
            case .some(let reader): self.body = .input(reader)
            }
        }
    }

    var outputStream: ((UnsafeStreamWriter) throws -> Void)? {
        get {
            guard case .output(let writer) = body else {
                return nil
            }
            return writer
        }
        set {
            switch newValue {
            case .none: self.body = .none
            case .some(let writer): self.body = .output(writer)
            }
        }
    }
}

// MARK: Convenience

extension Request {
    public var string: String? {
        get {
            guard let bytes = bytes else {
                return nil
            }
            return String(bytes: bytes, encoding: .utf8)
        }
    }

    public var bytes: [UInt8]? {
        get {
            switch body {
            case .bytes(let bytes): return bytes
            case .input(_):
                guard let bytes = try? readBytes() else {
                    return nil
                }
                return bytes
            default: return nil
            }
        }
        set {
            switch newValue {
            case .none:
                self.body = .none
            case .some(let bytes):
                self.body = .bytes(bytes)
                self.contentLength = bytes.count
            }
        }
    }

    func readBytes() throws -> [UInt8] {
        guard let reader = inputStream else {
            throw ParseError.invalidRequest
        }
        do {
            let bytes: [UInt8]
            if let contentLength = contentLength {
                let buffer = try reader.read(count: contentLength)
                bytes = [UInt8](buffer)
            } else if self.transferEncoding?.contains(.chunked) == true  {
                let stream = ChunkedInputStream(baseStream: reader)
                let buffer = try stream.read(
                    while: {_ in true},
                    allowingExhaustion: true)
                bytes = [UInt8](buffer)
            } else {
                throw ParseError.invalidRequest
            }
            // cache
            body = .bytes(bytes)
            return bytes
        } catch let error as StreamError where error == .insufficientData {
            throw ParseError.unexpectedEnd
        }
    }
}

extension Request {
    public convenience init<T: Encodable>(
        method: Method,
        url: URL,
        body: T,
        contentType type: ApplicationSubtype = .json
    ) throws {
        self.init()
        self.method = method
        self.url = url

        switch type {
        case .json:
            self.contentType = .json
            self.bytes = try JSON.encode(body)

        case .formURLEncoded:
            self.contentType = .formURLEncoded
            self.bytes = try FormURLEncoded.encode(body)

        default:
            throw ParseError.unsupportedContentType
        }
    }
}
