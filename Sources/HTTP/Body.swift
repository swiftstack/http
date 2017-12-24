import Stream

enum Body {
    case none
    case bytes([UInt8])
    case input(UnsafeStreamReader)
    case output((UnsafeStreamWriter) throws -> Void)
}
