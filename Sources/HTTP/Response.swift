public struct Response {
    public var status: Status = .ok
    public var version: Version = .oneOne

    public var connection: String? = nil
    public var contentEncoding: String? = nil
    public var contentType: ContentType? = nil
    public var contentLength: Int? = nil
    public var transferEncoding: String? = nil

    public var headers: [String : String] = [:]

    public var rawBody: [UInt8]? = nil {
        didSet {
            contentLength = rawBody?.count
        }
    }

    public init() {
        self.contentLength = 0
    }
}

extension Response {
    public init(status: Status) {
        self.status = status
        self.contentLength = 0
    }

    public init(version: Version) {
        self.version = version
        self.contentLength = 0
    }

    public init(string: String) {
        contentType = .text
        rawBody = [UInt8](string.utf8)
        contentLength = rawBody!.count
    }

    public init(html: String) {
        contentType = .html
        rawBody = [UInt8](html.utf8)
        contentLength = rawBody!.count
    }

    public init(bytes: [UInt8]) {
        contentType = .stream
        rawBody = bytes
        contentLength = bytes.count
    }

    public init(json object: Any) throws {
        let bytes = try JSON.serialize(object)

        contentType = .json
        rawBody = bytes
        contentLength = bytes.count
    }

    public init(urlEncoded values: [String : String]) {
        let bytes = [UInt8](URL.encode(values: values).utf8)

        contentType = .urlEncoded
        rawBody = bytes
        contentLength = bytes.count
    }
}

extension Response {
    public var body: String? {
        guard let rawBody = rawBody else {
            return nil
        }
        return String(cString: rawBody + [0])
    }
}

extension Response {
    public var bytes: [UInt8] {
        var bytes: [UInt8] = []
        encode(to: &bytes)
        return bytes
    }

    func encode(to bytes: inout [UInt8]) {
        // Start line
        bytes.append(contentsOf: Constants.httpSlash)
        bytes.append(contentsOf: version.bytes)
        bytes.append(Character.whitespace)
        bytes.append(contentsOf: status.bytes)
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

        if let contentType = self.contentType {
            writeHeader(
                name: ResponseHeader.contentType.bytes,
                value: contentType.bytes)
        }

        if let contentLength = self.contentLength {
            writeHeader(
                name: ResponseHeader.contentLength.bytes,
                value: ASCII(String(contentLength)))
        }
        
        if let connection = self.connection {
            writeHeader(
                name: ResponseHeader.connection.bytes,
                value: ASCII(connection))
        }

        if let contentEncoding = self.contentEncoding {
            writeHeader(
                name: ResponseHeader.contentEncoding.bytes,
                value: ASCII(contentEncoding))
        }

        if let transferEncoding = self.transferEncoding {
            writeHeader(
                name: ResponseHeader.transferEncoding.bytes,
                value: ASCII(transferEncoding))
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

extension Response {
    public init(from bytes: [UInt8]) throws {
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        try self.init(from: buffer)
    }

    public init(from bytes: UnsafeRawBufferPointer) throws {
        var startIndex = 0
        var endIndex = Constants.httpSlash.count + Constants.oneOne.count
        self.version = try Version(from: bytes[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 1)
        guard let index =
            bytes.index(of: Character.cr, offset: startIndex) else {
                throw HTTPError.unexpectedEnd
        }
        endIndex = index

        self.status = try Status(from: bytes[startIndex..<endIndex])

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
                    guard let lineEnd = bytes.index(
                        of: Character.cr,
                        offset: startIndex) else {
                            throw HTTPError.unexpectedEnd
                    }
                    endIndex = lineEnd

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
                    case ResponseHeader.connection:
                        self.connection = headerValueString
                    case ResponseHeader.contentEncoding:
                        self.contentEncoding = headerValueString
                    case ResponseHeader.contentLength:
                        self.contentLength = Int(headerValueString)
                    case ResponseHeader.contentType:
                        self.contentType = try ContentType(from: headerValue)
                    case ResponseHeader.transferEncoding:
                        self.transferEncoding = headerValueString
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
            transferEncoding.utf8.elementsEqual(Constants.chunked) else {
                return
        }

        self.rawBody = []

        while startIndex + Constants.minimumChunkLength <= bytes.endIndex {
            guard let chunkEnd =
                bytes.index(of: Character.cr, offset: startIndex) else {
                    throw HTTPError.unexpectedEnd
            }
            endIndex = chunkEnd
            
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
