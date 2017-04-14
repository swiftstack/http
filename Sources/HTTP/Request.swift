import class Foundation.JSONSerialization

public struct Request {
    public var method: Method
    public var url: URL
    public var version: Version

    public var host: String? = nil
    public var userAgent: String? = nil
    public var accept: String? = nil
    public var acceptLanguage: String? = nil
    public var acceptEncoding: String? = nil
    public var acceptCharset: String? = nil
    public var keepAlive: Int? = nil
    public var connection: String? = nil
    public var contentType: ContentType? = nil
    public var contentLength: Int? = nil
    public var transferEncoding: String? = nil

    public var customHeaders: [String : String] = [:]

    public var rawBody: [UInt8]? = nil {
        didSet {
            contentLength = rawBody?.count
        }
    }
}

extension Request {
    public var shouldKeepAlive: Bool {
        if self.connection?.lowercased() == "close" {
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
                name: RequestHeader.host.bytes,
                value: ASCII(host))
        }

        if let contentType = self.contentType {
            writeHeader(
                name: RequestHeader.contentType.bytes,
                value: contentType.bytes)
        }

        if let contentLength = self.contentLength {
            let length = String(contentLength)
            writeHeader(
                name: RequestHeader.contentLength.bytes,
                value: ASCII(length))
        }

        if let userAgent = self.userAgent {
            writeHeader(
                name: RequestHeader.userAgent.bytes,
                value: ASCII(userAgent))
        }

        if let accept = self.accept {
            writeHeader(
                name: RequestHeader.accept.bytes,
                value: ASCII(accept))
        }

        if let acceptLanguage = self.acceptLanguage {
            writeHeader(
                name: RequestHeader.acceptLanguage.bytes,
                value: ASCII(acceptLanguage))
        }

        if let acceptEncoding = self.acceptEncoding {
            writeHeader(
                name: RequestHeader.acceptEncoding.bytes,
                value: ASCII(acceptEncoding))
        }

        if let acceptCharset = self.acceptCharset {
            writeHeader(
                name: RequestHeader.acceptCharset.bytes,
                value: ASCII(acceptCharset))
        }

        if let keepAlive = self.keepAlive {
            writeHeader(
                name: RequestHeader.keepAlive.bytes,
                value: ASCII(String(keepAlive)))
        }

        if let connection = self.connection {
            writeHeader(
                name: RequestHeader.connection.bytes,
                value: ASCII(connection))
        }

        if let transferEncoding = self.transferEncoding {
            writeHeader(
                name: RequestHeader.transferEncoding.bytes,
                value: ASCII(transferEncoding))
        }

        for (key, value) in customHeaders {
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
        var endIndex = try bytes.index(of: Character.whitespace, offset: startIndex)
        self.method = try Request.Method(from: bytes[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 1)
        endIndex = try bytes.index(of: Character.whitespace, offset: startIndex)
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

                endIndex = try bytes.index(
                    of: Character.colon,
                    offset: startIndex)
                let headerNameBuffer = bytes[startIndex..<endIndex]
                let headerName = try HeaderName(from: headerNameBuffer)

                startIndex = endIndex.advanced(by: 1)
                endIndex = try bytes.index(
                    of: Character.cr,
                    offset: startIndex)

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
                case RequestHeader.host:
                    self.host = headerValueString
                case RequestHeader.userAgent:
                    self.userAgent = headerValueString
                case RequestHeader.accept:
                    self.accept = headerValueString
                case RequestHeader.acceptLanguage:
                    self.acceptLanguage = headerValueString
                case RequestHeader.acceptEncoding:
                    self.acceptEncoding = headerValueString
                case RequestHeader.acceptCharset:
                    self.acceptCharset = headerValueString
                case RequestHeader.keepAlive:
                    self.keepAlive = Int(headerValueString)
                case RequestHeader.connection:
                    self.connection = headerValueString
                case RequestHeader.contentLength:
                    self.contentLength = Int(headerValueString)
                case RequestHeader.contentType:
                    self.contentType = try ContentType(from: headerValue)
                case RequestHeader.transferEncoding:
                    self.transferEncoding = headerValueString
                default:
                    let headerNameString = String(buffer: headerNameBuffer)
                    customHeaders[headerNameString] = headerValueString
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
            transferEncoding.utf8.elementsEqual(Constants.chunked) else {
                return
        }

        self.rawBody = []

        while startIndex + Constants.minimumChunkLength <= bytes.endIndex {
            endIndex = try bytes.index(of: Character.cr, offset: startIndex)
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
