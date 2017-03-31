enum RequestError: Error {
    case invalidRequest
    case invalidMethod
    case invalidVersion
    case invalidHeaderName
    case unexpectedEnd
}

public struct Request {
    public var type: Kind
    public var version: Version
    public var url: URL

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

    public var customHeaders: [HeaderName: String] = [:]

    public var rawBody: [UInt8]? = nil
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

    public init(type: Kind = .get, url: URL) {
        self.type = type
        self.version = .oneOne
        self.url = url
        self.rawBody = []
    }
}

extension Request {
    public init(from bytes: [UInt8]) throws {
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        try self.init(from: buffer)
    }

    public init(from buffer: UnsafeRawBufferPointer) throws {
        var startIndex = 0
        var endIndex = try buffer.index(of: Character.whitespace, offset: startIndex)
        self.type = try Request.Kind(from: buffer[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 1)
        endIndex = try buffer.index(of: Character.whitespace, offset: startIndex)
        self.url = URL(from: buffer[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 1)
        endIndex = startIndex + Constants.versionLength
        guard endIndex < buffer.endIndex else {
            throw RequestError.unexpectedEnd
        }

        self.version = try Version(from: buffer[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 2)
        guard startIndex < buffer.endIndex else {
            throw RequestError.unexpectedEnd
        }
        guard buffer[endIndex..<startIndex]
            .elementsEqual(Constants.lineEnd) else {
                throw RequestError.invalidRequest
        }

        while startIndex + Constants.minimumHeaderLength < buffer.endIndex
            && !buffer.suffix(from: startIndex).starts(with: Constants.lineEnd) {

                endIndex = try buffer.index(of: Character.colon, offset: startIndex)
                let headerName = try HeaderName(from: buffer[startIndex..<endIndex])

                startIndex = endIndex.advanced(by: 1)
                endIndex = try buffer.index(of: Character.cr, offset: startIndex)

                var headerValue = buffer[startIndex..<endIndex]
                if headerValue[0] == Character.whitespace {
                    headerValue = headerValue.dropFirst()
                }
                if headerValue[headerValue.endIndex-1] == Character.whitespace {
                    headerValue = headerValue.dropLast()
                }

                let headerValueString = String(buffer: headerValue)
                switch headerName {
                case HeaderName.host: self.host = headerValueString
                case HeaderName.userAgent: self.userAgent = headerValueString
                case HeaderName.accept: self.accept = headerValueString
                case HeaderName.acceptLanguage: self.acceptLanguage = headerValueString
                case HeaderName.acceptEncoding: self.acceptEncoding = headerValueString
                case HeaderName.acceptCharset: self.acceptCharset = headerValueString
                case HeaderName.keepAlive: self.keepAlive = Int(headerValueString)
                case HeaderName.connection: self.connection = headerValueString
                case HeaderName.contentLength: self.contentLength = Int(headerValueString)
                case HeaderName.contentType: self.contentType = ContentType(rawValue: headerValueString)
                case HeaderName.transferEncoding: self.transferEncoding = headerValueString
                default: customHeaders[headerName] = headerValueString
                }

                startIndex = endIndex.advanced(by: 2)
        }

        guard startIndex + 2 <= buffer.endIndex,
            buffer[startIndex] == Character.cr,
            buffer[startIndex + 1] == Character.lf else {
                throw RequestError.unexpectedEnd
        }
        buffer.formIndex(&startIndex, offsetBy: 2)

        // Body

        self.rawBody = []

        // 1. content-lenght
        if let length = self.contentLength {
            endIndex = startIndex.advanced(by: length)
            guard endIndex <= buffer.endIndex else {
                throw RequestError.unexpectedEnd
            }
            self.rawBody = [UInt8](buffer[startIndex..<endIndex])
            return
        }

        // 2. chunked
        guard let transferEncoding = self.transferEncoding,
            transferEncoding.utf8.elementsEqual(Constants.chunked) else {
                return
        }

        while startIndex + Constants.minimumChunkLength <= buffer.endIndex {
            endIndex = try buffer.index(of: Character.cr, offset: startIndex)
            guard buffer[endIndex.advanced(by: 1)] == Character.lf else {
                throw RequestError.invalidRequest
            }

            // TODO: optimize using hex table
            let hexSize = String(buffer: buffer[startIndex..<endIndex])
            guard let size = Int(hexSize, radix: 16) else {
                throw RequestError.invalidRequest
            }
            guard size > 0 else {
                startIndex = endIndex.advanced(by: 2)
                break
            }

            startIndex = endIndex.advanced(by: 2)
            endIndex = startIndex.advanced(by: size)
            guard endIndex < buffer.endIndex else {
                throw RequestError.unexpectedEnd
            }

            rawBody?.append(contentsOf: [UInt8](buffer[startIndex..<endIndex]))
            startIndex = endIndex.advanced(by: 2)
        }


        guard startIndex == buffer.endIndex || (
            startIndex == buffer.endIndex.advanced(by: -2) &&
                buffer.suffix(from: startIndex)
                    .elementsEqual(Constants.lineEnd)) else {
                        throw RequestError.unexpectedEnd
        }
    }
}
