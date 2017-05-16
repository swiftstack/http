import JSON

public struct Response {
    public var status: Status = .ok
    public var version: Version = .oneOne

    public var connection: Connection? = nil
    public var contentEncoding: [ContentEncoding]? = nil
    public var contentType: ContentType? = nil
    public var contentLength: Int? = nil
    public var transferEncoding: [TransferEncoding]? = nil

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
        let bytes = try JSON.encode(object)

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
        var bytes = [UInt8]()
        encode(to: &bytes)
        return bytes
    }

    func encode(to buffer: inout [UInt8]) {
        // Start line
        version.encode(to: &buffer)
        buffer.append(Character.whitespace)
        status.encode(to: &buffer)
        buffer.append(contentsOf: Constants.lineEnd)

        // Headers
        @inline(__always)
        func writeHeader(name: [UInt8], encoder: (inout [UInt8]) -> Void) {
            buffer.append(contentsOf: name)
            buffer.append(Character.colon)
            buffer.append(Character.whitespace)
            encoder(&buffer)
            buffer.append(contentsOf: Constants.lineEnd)
        }

        @inline(__always)
        func writeHeader(name: [UInt8], value: [UInt8]) {
            buffer.append(contentsOf: name)
            buffer.append(Character.colon)
            buffer.append(Character.whitespace)
            buffer.append(contentsOf: value)
            buffer.append(contentsOf: Constants.lineEnd)
        }

        if let contentType = self.contentType {
            writeHeader(
                name: HeaderNames.contentType.bytes,
                encoder: contentType.encode)
        }

        if let contentLength = self.contentLength {
            writeHeader(
                name: HeaderNames.contentLength.bytes,
                value: ASCII(String(contentLength)))
        }
        
        if let connection = self.connection {
            writeHeader(
                name: HeaderNames.connection.bytes,
                encoder: connection.encode)
        }

        if let contentEncoding = self.contentEncoding {
            writeHeader(
                name: HeaderNames.contentEncoding.bytes,
                encoder: contentEncoding.encode)
        }

        if let transferEncoding = self.transferEncoding {
            writeHeader(
                name: HeaderNames.transferEncoding.bytes,
                encoder: transferEncoding.encode)
        }

        for (key, value) in headers {
            writeHeader(
                name: ASCII(key),
                value: ASCII(value))
        }

        // Separator
        buffer.append(contentsOf: Constants.lineEnd)

        // Body
        if let rawBody = rawBody {
            buffer.append(contentsOf: rawBody)
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
        guard let index = bytes.index(of: Character.whitespace) else {
            throw HTTPError.unexpectedEnd
        }
        var endIndex = index
        self.version = try Version(from: bytes[startIndex..<endIndex])

        startIndex = endIndex.advanced(by: 1)
        guard let lineEnd =
            bytes.index(of: Character.cr, offset: startIndex) else {
                throw HTTPError.unexpectedEnd
        }
        endIndex = lineEnd
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

                    let headerValue = bytes[startIndex..<endIndex]
                        .trimmingLeftSpace()
                        .trimmingRightSpace()

                    let headerValueString = String(buffer: headerValue)
                    switch headerName {
                    case HeaderNames.connection:
                        self.connection = try Connection(from: headerValue)
                    case HeaderNames.contentEncoding:
                        self.contentEncoding =
                            try [ContentEncoding](from: headerValue)
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
