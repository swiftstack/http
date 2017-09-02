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

    public var setCookie: [SetCookie] = []

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

    public init(json object: Encodable) throws {
        let encoder = JSONEncoder()
        let json = try encoder.encode(object)

        contentType = ContentType(mediaType: .application(.json))
        rawBody = [UInt8](json.utf8)
        contentLength = rawBody!.count
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

        for cookie in self.setCookie {
            writeHeader(.setCookie, encoder: cookie.encode)
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
