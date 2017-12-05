import KeyValueCodable

struct URLFormEncoded {
    static func encode<T: Encodable>(
        _ object: T
    ) throws -> [UInt8] {
        let values = try KeyValueEncoder().encode(object)
        let query = URL.Query(values: values)
        var urlEncodedBytes = [UInt8]()
        query.encode(to: &urlEncodedBytes)
        return urlEncodedBytes
    }

    // FIXME: the same interface shadows the generic one
    static func encode(
        encodable object: Encodable
    ) throws -> [UInt8] {
        let values = try KeyValueEncoder().encode(encodable: object)
        let query = URL.Query(values: values)
        var urlEncodedBytes = [UInt8]()
        query.encode(to: &urlEncodedBytes)
        return urlEncodedBytes
    }
}
