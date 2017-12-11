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

    // Response headers
    static let setCookie = HeaderName("Set-Cookie")
}

public struct HeaderName: Hashable {
    let bytes: [UInt8]
    init(from buffer: UnsafeRawBufferPointer.SubSequence) throws {
        for byte in buffer {
            guard ASCIICharacterSet.token.contains(byte) else {
                throw HTTPError.invalidHeaderName
            }
        }
        bytes = [UInt8](buffer)
    }

    public init(_ value: String) {
        bytes = [UInt8](value.utf8)
    }

    public var hashValue: Int {
        return bytes.lowercasedHashValue
    }
}

extension HeaderName: CustomStringConvertible {
    public var description: String {
        return String(bytes: bytes, encoding: .utf8)!
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
