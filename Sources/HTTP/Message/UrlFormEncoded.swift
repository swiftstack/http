struct FormURLEncoded {
    static func encode<T: Encodable>(
        _ object: T
    ) throws -> [UInt8] {
        let values = try KeyValueEncoder().encode(object)
        let query = URL.Query(values: values)
        return query.encode()
    }

    // FIXME: the same interface shadows the generic one
    static func encode(
        encodable object: Encodable
    ) throws -> [UInt8] {
        let values = try KeyValueEncoder().encode(encodable: object)
        let query = URL.Query(values: values)
        return query.encode()
    }
}
