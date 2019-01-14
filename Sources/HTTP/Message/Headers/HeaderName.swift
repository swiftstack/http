extension HeaderName {
    // General headers
    static let connection = HeaderName("Connection")
    static let keepAlive = HeaderName("Keep-Alive")

    // Entity headers
    static let contentLength = HeaderName("Content-Length")
    static let contentType = HeaderName("Content-Type")
    static let contentEncoding = HeaderName("Content-Encoding")
    static let transferEncoding = HeaderName("Transfer-Encoding")

    // Request headers
    static let host = HeaderName("Host")
    static let userAgent = HeaderName("User-Agent")
    static let accept = HeaderName("Accept")
    static let acceptLanguage = HeaderName("Accept-Language")
    static let acceptEncoding = HeaderName("Accept-Encoding")
    static let acceptCharset = HeaderName("Accept-Charset")
    static let authorization = HeaderName("Authorization")
    static let cookie = HeaderName("Cookie")
    static let expect = HeaderName("Expect")

    // Response headers
    static let setCookie = HeaderName("Set-Cookie")
}

public struct HeaderName: Hashable {
    let bytes: [UInt8]

    public let _hashValue: Int

    init(_ bytes: [UInt8]) {
        self.bytes = bytes
        self._hashValue = bytes.lowercasedHashValue
    }

    public init(_ value: String) {
        self.init([UInt8](value.utf8))
    }

    // TODO: inline lowercasedHashValue, benchmark
    public func hash(into hasher: inout Hasher) {
       hasher.combine(_hashValue)
    }

    public static func ==(lhs: HeaderName, rhs: HeaderName) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension HeaderName: CustomStringConvertible {
    public var description: String {
        return String(decoding: bytes, as: UTF8.self)
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
