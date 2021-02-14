extension Request {
    public enum Authorization: Equatable {
        case basic(credentials: String)
        case bearer(credentials: String)
        case token(credentials: String)
        case custom(scheme: String, credentials: String)
    }
}
