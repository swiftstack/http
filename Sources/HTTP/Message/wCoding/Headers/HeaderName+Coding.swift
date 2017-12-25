import Stream

extension HeaderName {
    init<T: UnsafeStreamReader>(from stream: T) throws {
        let bytes = try stream.read(allowedBytes: .token)
        guard bytes.count > 0 else {
            throw ParseError.invalidHeaderName
        }
        self.init([UInt8](bytes))
    }
}
