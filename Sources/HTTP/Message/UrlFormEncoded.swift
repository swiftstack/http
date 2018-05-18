import Stream

struct FormURLEncoded {
    static func encode<T: Encodable, Stream: StreamWriter>(
        _ object: T,
        to stream: Stream
    ) throws {
        let values = try KeyValueEncoder().encode(object)
        let query = URL.Query(values: values)
        try query.encode(to: stream)
    }

    // FIXME: the same interface shadows the generic one
    static func encode<Stream: StreamWriter>(
        encodable object: Encodable,
        to stream: Stream
    ) throws {
        let values = try KeyValueEncoder().encode(encodable: object)
        let query = URL.Query(values: values)
        try query.encode(to: stream)
    }
}

// FIXME: remove?
extension FormURLEncoded {
    static func encode<T: Encodable>(_ object: T) throws -> [UInt8] {
        let stream = OutputByteStream()
        try encode(object, to: stream)
        return stream.bytes
    }

    static func encode(encodable object: Encodable) throws -> [UInt8] {
        let stream = OutputByteStream()
        try encode(encodable: object, to: stream)
        return stream.bytes
    }
}
