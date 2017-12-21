extension Request {
    public enum Authorization {
        case basic(credentials: String)
        case bearer(credentials: String)
        case token(credentials: String)
        case custom(scheme: String, credentials: String)
    }
}

extension Request.Authorization: Equatable {
    public typealias Authorization = Request.Authorization
    public static func ==(lhs: Authorization, rhs: Authorization) -> Bool {
        switch (lhs, rhs) {
        case let (.basic(lhs), .basic(rhs)) where lhs == rhs: return true
        case let (.bearer(lhs), .bearer(rhs)) where lhs == rhs: return true
        case let (.token(lhs), .token(rhs)) where lhs == rhs: return true
        case let (.custom(lhs), .custom(rhs)) where lhs == rhs: return true
        default: return false
        }
    }
}
