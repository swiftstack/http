import Stream

public enum Body {
    case none
    case bytes([UInt8])
    case input(StreamReader)
    case output((StreamWriter) async throws -> Void)
}

extension Body: Equatable {
    public static func == (lhs: Body, rhs: Body) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none): return true
        case let (.bytes(lhs), .bytes(rhs)): return lhs == rhs
        default: return false
        }
    }
}
