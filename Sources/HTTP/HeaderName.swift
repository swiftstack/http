struct HeaderName: Hashable {
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

    let name: ArraySlice<UInt8>
    init(validatingCharacters bytes: ArraySlice<UInt8>) throws {
        for byte in bytes {
            guard Int(byte) < tokens.count && tokens[Int(byte)] else {
                throw RequestError.invalidHeaderName
            }
        }
        name = bytes
    }
    fileprivate init(_ value: String) {
        name = ArraySlice<UInt8>(value.utf8)
    }
    var hashValue: Int {
        var hash = 5381
        for byte in name {
            hash = ((hash << 5) &+ hash) &+ Int(byte | 0x20)
        }
        return hash
    }
}

extension HeaderName: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(value)
    }
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}

func == (lhs: HeaderName, rhs: HeaderName) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
