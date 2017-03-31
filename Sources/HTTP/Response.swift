public struct Response {
    public var status: Status = .ok
    public var version: Version = .oneOne
    public var contentType: ContentType?
    public var rawBody: [UInt8]? = nil
    public var contentLength: Int {
        return rawBody?.count ?? 0
    }

    public init() {
    }

    public init(status: Status) {
        self.status = status
    }

    public init(version: Version) {
        self.version = version
    }

    public init(string: String) {
        contentType = .text
        rawBody = [UInt8](string.utf8)
    }

    public init(html: String) {
        contentType = .html
        rawBody = [UInt8](html.utf8)
    }

    public init(bytes: [UInt8]) {
        contentType = .stream
        rawBody = bytes
    }

    public init(json: [UInt8]) {
        contentType = .json
        rawBody = json
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

        // Start line
        bytes.append(contentsOf: Constants.httpSlash)
        bytes.append(contentsOf: version.bytes)
        bytes.append(Character.whitespace)
        bytes.append(contentsOf: status.bytes)
        bytes.append(contentsOf: Constants.lineEnd)

        // Headers
        if let contentType = contentType {
            bytes.append(contentsOf: StandartHeaders.contentType)
            bytes.append(Character.colon)
            bytes.append(Character.whitespace)
            bytes.append(contentsOf: contentType.bytes)
            bytes.append(contentsOf: Constants.lineEnd)
        }

        bytes.append(contentsOf: StandartHeaders.contentLength)
        bytes.append(Character.colon)
        bytes.append(Character.whitespace)
        bytes.append(contentsOf: ASCII(String(contentLength)))
        bytes.append(contentsOf: Constants.lineEnd)

        // Separator
        bytes.append(contentsOf: Constants.lineEnd)

        // Body
        if let rawBody = rawBody {
            bytes.append(contentsOf: rawBody)
        }

        return bytes
    }
}
