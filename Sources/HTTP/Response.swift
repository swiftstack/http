import JSON

public struct Response {
    public var status: Status = .ok
    public var version: Version = .oneOne

    public var connection: Connection? = nil
    public var contentEncoding: [ContentEncoding]? = nil
    public var contentType: ContentType? = nil
    public var contentLength: Int? = nil
    public var transferEncoding: [TransferEncoding]? = nil

    public var headers: [HeaderName : String] = [:]

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
        contentType = ContentType(mediaType: .text(.plain))
        rawBody = [UInt8](string.utf8)
        contentLength = rawBody!.count
    }

    public init(html: String) {
        contentType = ContentType(mediaType: .text(.html))
        rawBody = [UInt8](html.utf8)
        contentLength = rawBody!.count
    }

    public init(bytes: [UInt8]) {
        contentType = ContentType(mediaType: .application(.stream))
        rawBody = bytes
        contentLength = bytes.count
    }

    public init(json object: Any) throws {
        let bytes = try JSON.encode(object)

        contentType = ContentType(mediaType: .application(.json))
        rawBody = bytes
        contentLength = bytes.count
    }

    public init(urlEncoded query: URL.Query) {
        var urlEncodedBytes = [UInt8]()
        query.encode(to: &urlEncodedBytes)

        contentType = ContentType(mediaType: .application(.urlEncoded))
        rawBody = urlEncodedBytes
        contentLength = urlEncodedBytes.count
    }
}

extension Response {
    public var body: String? {
        guard let rawBody = rawBody else {
            return nil
        }
        return String(bytes: rawBody, encoding: .utf8)
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

        if let contentType = self.contentType {
            writeHeader(.contentType, encoder: contentType.encode)
        }

        if let contentLength = self.contentLength {
            writeHeader(.contentLength, value: String(contentLength))
        }
        
        if let connection = self.connection {
            writeHeader(.connection, encoder: connection.encode)
        }

        if let contentEncoding = self.contentEncoding {
            writeHeader(.contentEncoding, encoder: contentEncoding.encode)
        }

        if let transferEncoding = self.transferEncoding {
            writeHeader(.transferEncoding, encoder: transferEncoding.encode)
        }

        for (key, value) in headers {
            writeHeader(key, value: value)
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
        try self.init(from: buffer[...])
    }

    public init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        var startIndex = 0
        guard let whitespace = bytes.index(of: Character.whitespace) else {
            throw HTTPError.unexpectedEnd
        }
        var endIndex = whitespace
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
            && !bytes[startIndex...].starts(with: Constants.lineEnd) {
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

                    switch headerName {
                    case .connection:
                        self.connection = try Connection(from: headerValue)
                    case .contentEncoding:
                        self.contentEncoding =
                            try [ContentEncoding](from: headerValue)
                    case .contentLength:
                        self.contentLength = Int(String(buffer: headerValue))
                    case .contentType:
                        self.contentType = try ContentType(from: headerValue)
                    case .transferEncoding:
                        self.transferEncoding =
                            try [TransferEncoding](from: headerValue)
                    default:
                        headers[headerName] = String(buffer: headerValue)
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
                bytes[startIndex...].elementsEqual(Constants.lineEnd)) else {
                    throw HTTPError.unexpectedEnd
        }
    }
}
