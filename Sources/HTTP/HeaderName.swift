public struct HeaderName: Hashable {
    static let host = HeaderName("host")
    static let userAgent = HeaderName("user-agent")
    static let accept = HeaderName("accept")
    static let acceptLanguage = HeaderName("accept-language")
    static let acceptEncoding = HeaderName("accept-encoding")
    static let acceptCharset = HeaderName("accept-charset")
    static let keepAlive = HeaderName("keep-alive")
    static let connection = HeaderName("connection")
    static let contentLength = HeaderName("content-length")
    static let contentType = HeaderName("content-type")
    static let transferEncoding = HeaderName("transfer-encoding")

    let name: [UInt8]
    init(from buffer: UnsafeRawBufferPointer) throws {
        for byte in buffer {
            guard Int(byte) < tokens.count && tokens[Int(byte)] else {
                throw RequestError.invalidHeaderName
            }
        }
        name = [UInt8](buffer)
    }

    public init(_ value: String) {
        name = [UInt8](value.utf8)
    }

    public var hashValue: Int {
        return name.hashValue
    }
}

extension HeaderName: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}

public func == (lhs: HeaderName, rhs: HeaderName) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
