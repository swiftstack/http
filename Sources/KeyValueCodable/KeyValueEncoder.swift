public struct KeyValueEncoder {
    public init() {}

    public func encode<T: Encodable>(
        _ value: T
    ) throws -> [String : String] {
        let encoder = _KeyValueEncoder()
        try value.encode(to: encoder)
        return encoder.values
    }
}

class _KeyValueEncoder: Encoder {
    var codingPath: [CodingKey?] {
        return []
    }
    var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    var values: [String : String] = [:]

    func container<Key>(
        keyedBy type: Key.Type
    ) -> KeyedEncodingContainer<Key> {
        let container = KeyValueKeyedEncodingContainer<Key>(self)
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("unsupported container")
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError("unsupported container")
    }
}

struct KeyValueKeyedEncodingContainer<K: CodingKey>
: KeyedEncodingContainerProtocol {
    typealias Key = K

    var codingPath: [CodingKey?] {
        return []
    }

    let encoder: _KeyValueEncoder
    init(_ encoder: _KeyValueEncoder) {
        self.encoder = encoder
    }

    mutating func encode(_ value: Bool, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: Int, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: Int8, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: Int16, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: Int32, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: Int64, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: UInt, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: UInt8, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: UInt16, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: UInt32, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: UInt64, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: Float, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: Double, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode(_ value: String, forKey key: K) throws {
        encoder.values[key.stringValue] = value.description
    }

    mutating func encode<T>(
        _ value: T, forKey key: K
    ) throws where T : Encodable {
        fatalError("unsupported")
    }

    mutating func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: K
    ) -> KeyedEncodingContainer<NestedKey> {
        fatalError("unsupported")
    }

    mutating func nestedUnkeyedContainer(
        forKey key: K
    ) -> UnkeyedEncodingContainer {
        fatalError("unsupported")
    }

    mutating func superEncoder() -> Encoder {
        return encoder
    }

    mutating func superEncoder(forKey key: K) -> Encoder {
        fatalError("unsupported")
    }
}
