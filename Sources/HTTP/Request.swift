import class Foundation.JSONSerialization

public struct Request {
    public var method: Method
    public var url: URL
    public var version: Version

    public var host: String? = nil
    public var userAgent: String? = nil
    public var accept: String? = nil
    public var acceptLanguage: String? = nil
    public var acceptEncoding: [ContentEncoding]? = nil
    public var acceptCharset: [AcceptCharset]? = nil
    public var keepAlive: Int? = nil
    public var connection: Connection? = nil
    public var contentType: ContentType? = nil
    public var contentLength: Int? = nil
    public var transferEncoding: [TransferEncoding]? = nil

    public var headers: [String : String] = [:]

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
        guard let bytes = rawBody else {
            return nil
        }
        return String(bytes: bytes)
    }

    public init(method: Method = .get, url: URL = URL(path: "/")) {
        self.method = method
        self.url = url
        self.version = .oneOne
    }
}

extension Request {
    public init(method: Method, url: URL, json object: Any) throws {
        let bytes = [UInt8](try JSONSerialization.data(withJSONObject: object))
        self.init(method: method, url: url)
        self.contentType = .json
        self.rawBody = bytes
        self.contentLength = bytes.count
    }

    public init(
        method: Method,
        url: URL,
        urlEncoded values: [String : String]
    ) throws {
        let bytes = [UInt8](URL.encode(values: values).utf8)

        self.init(method: method, url: url)
        self.contentType = .urlEncoded
        self.rawBody = bytes
        self.contentLength = bytes.count
    }
}

extension Request {
    public var bytes: [UInt8] {
        var bytes = [UInt8]()
        encode(to: &bytes)
        return bytes
    }

    func encode(to bytes: inout [UInt8]) {
        // Start Line
        bytes.append(contentsOf: method.bytes)
        bytes.append(Character.whitespace)
        bytes.append(contentsOf: url.bytes)
        bytes.append(Character.whitespace)
        bytes.append(contentsOf: Constants.httpSlash)
        bytes.append(contentsOf: Constants.oneOne)
        bytes.append(contentsOf: Constants.lineEnd)

        // Headers
        @inline(__always)
        func writeHeader(name: [UInt8], value: [UInt8]) {
            bytes.append(contentsOf: name)
            bytes.append(Character.colon)
            bytes.append(Character.whitespace)
            bytes.append(contentsOf: value)
            bytes.append(contentsOf: Constants.lineEnd)
        }

        if let host = self.host {
            writeHeader(
                name: HeaderNames.host.bytes,
                value: ASCII(host))
        }

        if let contentType = self.contentType {
            writeHeader(
                name: HeaderNames.contentType.bytes,
                value: contentType.bytes)
        }

        if let contentLength = self.contentLength {
            let length = String(contentLength)
            writeHeader(
                name: HeaderNames.contentLength.bytes,
                value: ASCII(length))
        }

        if let userAgent = self.userAgent {
            writeHeader(
                name: HeaderNames.userAgent.bytes,
                value: ASCII(userAgent))
        }

        if let accept = self.accept {
            writeHeader(
                name: HeaderNames.accept.bytes,
                value: ASCII(accept))
        }

        if let acceptLanguage = self.acceptLanguage {
            writeHeader(
                name: HeaderNames.acceptLanguage.bytes,
                value: ASCII(acceptLanguage))
        }

        if let acceptEncoding = self.acceptEncoding {
            writeHeader(
                name: HeaderNames.acceptEncoding.bytes,
                value: acceptEncoding.bytes)
        }

        if let acceptCharset = self.acceptCharset {
            writeHeader(
                name: HeaderNames.acceptCharset.bytes,
                value: acceptCharset.bytes)
        }

        if let keepAlive = self.keepAlive {
            writeHeader(
                name: HeaderNames.keepAlive.bytes,
                value: ASCII(String(keepAlive)))
        }

        if let connection = self.connection {
            writeHeader(
                name: HeaderNames.connection.bytes,
                value: ASCII(connection.bytes))
        }

        if let transferEncoding = self.transferEncoding {
            writeHeader(
                name: HeaderNames.transferEncoding.bytes,
                value: transferEncoding.bytes)
        }

        for (key, value) in headers {
            writeHeader(name: ASCII(key), value: ASCII(value))
        }

        // Separator
        bytes.append(contentsOf: Constants.lineEnd)

        // Body
        if let rawBody = rawBody {
            bytes.append(contentsOf: rawBody)
        }
    }
}

extension Request {
    public init(from bytes: [UInt8]) throws {
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        try self.init(from: buffer)
    }

    public init(from bytes: UnsafeRawBufferPointer) throws {
        var startIndex = 0
        guard let index =
            bytes.index(of: Character.whitespace, offset: startIndex) else {
                throw HTTPError.unexpectedEnd
        }
        var endIndex = index
        self.method = try Request.Method(from: bytes[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 1)
        guard let urlEndIndex =
            bytes.index(of: Character.whitespace, offset: startIndex) else {
                throw HTTPError.unexpectedEnd
        }
        endIndex = urlEndIndex
        self.url = URL(from: bytes[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 1)
        endIndex = startIndex + Constants.versionLength
        guard endIndex < bytes.endIndex else {
            throw HTTPError.unexpectedEnd
        }

        self.version = try Version(from: bytes[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 2)
        guard startIndex < bytes.endIndex else {
            throw HTTPError.unexpectedEnd
        }
        guard bytes[endIndex..<startIndex]
            .elementsEqual(Constants.lineEnd) else {
                throw HTTPError.invalidRequest
        }

        while startIndex + Constants.minimumHeaderLength < bytes.endIndex
            && !bytes.suffix(from: startIndex)
                .starts(with: Constants.lineEnd) {

                guard let headerNameEndIndex = bytes.index(
                    of: Character.colon,
                    offset: startIndex) else {
                        throw HTTPError.unexpectedEnd
                }
                endIndex = headerNameEndIndex
                let headerNameBuffer = bytes[startIndex..<endIndex]
                let headerName = try HeaderName(from: headerNameBuffer)

                startIndex = endIndex.advanced(by: 1)
                guard let headerValueEndIndex = bytes.index(
                    of: Character.cr,
                    offset: startIndex) else {
                        throw HTTPError.unexpectedEnd
                }
                endIndex = headerValueEndIndex

                var headerValue = bytes[startIndex..<endIndex]
                if headerValue[0] == Character.whitespace {
                    headerValue = headerValue.dropFirst()
                }
                if headerValue[headerValue.endIndex-1]
                    == Character.whitespace {
                        headerValue = headerValue.dropLast()
                }

                let headerValueString = String(buffer: headerValue)
                switch headerName {
                case HeaderNames.host:
                    self.host = headerValueString
                case HeaderNames.userAgent:
                    self.userAgent = headerValueString
                case HeaderNames.accept:
                    self.accept = headerValueString
                case HeaderNames.acceptLanguage:
                    self.acceptLanguage = headerValueString
                case HeaderNames.acceptEncoding:
                    self.acceptEncoding =
                        try [ContentEncoding](from: headerValue)
                case HeaderNames.acceptCharset:
                    self.acceptCharset = try [AcceptCharset](from: headerValue)
                case HeaderNames.keepAlive:
                    self.keepAlive = Int(headerValueString)
                case HeaderNames.connection:
                    self.connection = try Connection(from: headerValue)
                case HeaderNames.contentLength:
                    self.contentLength = Int(headerValueString)
                case HeaderNames.contentType:
                    self.contentType = try ContentType(from: headerValue)
                case HeaderNames.transferEncoding:
                    self.transferEncoding =
                        try [TransferEncoding](from: headerValue)
                default:
                    let headerNameString = String(buffer: headerNameBuffer)
                    headers[headerNameString] = headerValueString
                }

                startIndex = endIndex.advanced(by: 2)
        }

        guard startIndex + 2 <= bytes.endIndex,
            bytes[startIndex] == Character.cr,
            bytes[startIndex + 1] == Character.lf else {
                throw HTTPError.unexpectedEnd
        }
        bytes.formIndex(&startIndex, offsetBy: 2)

        // Body

        // 1. content-lenght
        if let length = self.contentLength {
            guard length > 0 else {
                self.rawBody = nil
                return
            }
            endIndex = startIndex.advanced(by: length)
            guard endIndex <= bytes.endIndex else {
                throw HTTPError.unexpectedEnd
            }
            self.rawBody = [UInt8](bytes[startIndex..<endIndex])
            return
        }

        // 2. chunked
        guard let transferEncoding = self.transferEncoding,
            transferEncoding.contains(.chunked) else {
                return
        }

        self.rawBody = []

        while startIndex + Constants.minimumChunkLength <= bytes.endIndex {
            guard let lineEndIndex =
                bytes.index(of: Character.cr, offset: startIndex) else {
                    throw HTTPError.unexpectedEnd
            }
            endIndex = lineEndIndex
            guard bytes[endIndex.advanced(by: 1)] == Character.lf else {
                throw HTTPError.invalidRequest
            }

            // TODO: optimize using hex table
            let hexSize = String(buffer: bytes[startIndex..<endIndex])
            guard let size = Int(hexSize, radix: 16) else {
                throw HTTPError.invalidRequest
            }
            guard size > 0 else {
                startIndex = endIndex.advanced(by: 2)
                break
            }

            startIndex = endIndex.advanced(by: 2)
            endIndex = startIndex.advanced(by: size)
            guard endIndex < bytes.endIndex else {
                throw HTTPError.unexpectedEnd
            }

            rawBody!.append(contentsOf: [UInt8](bytes[startIndex..<endIndex]))
            startIndex = endIndex.advanced(by: 2)
        }


        guard startIndex == bytes.endIndex || (
            startIndex == bytes.endIndex.advanced(by: -2) &&
                bytes.suffix(from: startIndex)
                    .elementsEqual(Constants.lineEnd)) else {
                        throw HTTPError.unexpectedEnd
        }
    }
}
