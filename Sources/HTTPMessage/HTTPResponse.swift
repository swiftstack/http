public enum HTTPResponseStatus: String {
    case ok
    case moved
    case badRequest
    case unauthorized
    case notFound
    case internalServerError
}

public enum HTTPResponseContentType {
    case text
    case html
    case stream
    case json
}

public struct HTTPResponse {
    public var status: HTTPResponseStatus = .ok
    public var version: HTTPVersion = .oneOne
    public var contentType: HTTPResponseContentType?
    public var body: [UInt8]? = nil
    public var contentLength: Int {
        return body?.count ?? 0
    }

    public init() {
    }

    public init(status: HTTPResponseStatus) {
        self.status = status
    }

    public init(version: HTTPVersion) {
        self.version = version
    }

    public init(string: String) {
        contentType = .text
        body = [UInt8](string.utf8)
    }

    public init(html: String) {
        contentType = .html
        body = [UInt8](html.utf8)
    }

    public init(bytes: [UInt8]) {
        contentType = .stream
        body = bytes
    }

    public init(json: [UInt8]) {
        contentType = .json
        body = json
    }

    public var bytes: [UInt8] {
        var bytes: [UInt8] = []

        // Start line
        bytes.append(contentsOf: HTTPConstants.httpSlash)
        bytes.append(contentsOf: version.bytes)
        bytes.append(Character.whitespace)
        bytes.append(contentsOf: status.bytes)
        bytes.append(contentsOf: HTTPConstants.lineEnd)

        // Headers
        if let contentType = contentType {
            bytes.append(contentsOf: HeaderNameMapping.contentType)
            bytes.append(Character.colon)
            bytes.append(Character.whitespace)
            bytes.append(contentsOf: contentType.bytes)
            bytes.append(contentsOf: HTTPConstants.lineEnd)
        }

        bytes.append(contentsOf: HeaderNameMapping.contentLength)
        bytes.append(Character.colon)
        bytes.append(Character.whitespace)
        bytes.append(contentsOf: ASCII(String(contentLength)))
        bytes.append(contentsOf: HTTPConstants.lineEnd)

        // Separator
        bytes.append(contentsOf: HTTPConstants.lineEnd)

        // Body
        if let body = body {
            bytes.append(contentsOf: body)
        }

        return bytes
    }
}
