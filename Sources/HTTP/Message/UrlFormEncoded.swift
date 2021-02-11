import Stream

struct FormURLEncoded {
    static func encode<T: Encodable, Stream: StreamWriter>(
        _ object: T,
        to stream: Stream
    ) async throws {
        let values = try KeyValueEncoder().encode(object)
        let query = URL.Query(values: values)
        try await query.encode(to: stream)
    }

    // FIXME: the same interface shadows the generic one
    static func encode<Stream: StreamWriter>(
        encodable object: Encodable,
        to stream: Stream
    ) async throws {
        let values = try KeyValueEncoder().encode(encodable: object)
        let query = URL.Query(values: values)
        try await query.encode(to: stream)
    }
}

// FIXME: remove?
extension FormURLEncoded {
    static func encode<T: Encodable>(_ object: T) throws -> [UInt8] {
        // FIXME: [Concurrency]
        let values = try KeyValueEncoder().encode(object)
        return URL.Query(values: values).encode()
    }

    static func encode(encodable object: Encodable) throws -> [UInt8] {
        // FIXME: [Concurrency]
        let values = try KeyValueEncoder().encode(encodable: object)
        return URL.Query(values: values).encode()
    }
}
