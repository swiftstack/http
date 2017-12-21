extension Request {
    public struct AcceptCharset {
        public let charset: Charset
        public let priority: Double

        public init(_ charset: Charset, priority: Double = 1.0) {
            self.charset = charset
            self.priority = priority
        }
    }
}

extension Request.AcceptCharset: Equatable {
    public static func ==(
        lhs: Request.AcceptCharset,
        rhs: Request.AcceptCharset
    ) -> Bool {
        guard lhs.priority == rhs.priority else {
            return false
        }
        switch (lhs.charset, rhs.charset) {
        case (.utf8, .utf8): return true
        case (.isoLatin1, .isoLatin1): return true
        case (.any, .any): return true
        case let (.custom(lhs), .custom(rhs)): return lhs == rhs
        default: return false
        }
    }
}
