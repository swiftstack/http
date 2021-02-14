import Stream

extension HeaderName {
    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        let bytes = try await stream.read(allowedBytes: .token)
        guard bytes.count > 0 else {
            throw Error.invalidHeaderName
        }
        return .init(bytes)
    }
}
