public struct KeyValueDecoder: Decoder {
    public var codingPath: [CodingKey] {
        return []
    }
    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    let values: [String : String]
    public init(_ values: [String : String]) {
        self.values = values
    }

    public func container<Key>(
        keyedBy type: Key.Type
        ) throws -> KeyedDecodingContainer<Key> {
        let container = KeyValueKeyedDecodingContainer<Key>(self)
        return KeyedDecodingContainer(container)
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError("unsupported container")
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return KeyValueSingleValueDecodingContainer(self)
    }
}

struct KeyValueKeyedDecodingContainer<K : CodingKey>
: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey] {
        return []
    }
    var allKeys: [K] {
        return []
    }

    let decoder: KeyValueDecoder

    init(_ decoder: KeyValueDecoder) {
        self.decoder = decoder
    }

    func contains(_ key: K) -> Bool {
        return decoder.values[key.stringValue] != nil
    }

    func decodeNil(forKey key: K) throws -> Bool {
        return !contains(key)
    }

    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = Bool(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: Int.Type, forKey key: K) throws -> Int {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = Int(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = Int8(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = Int16(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = Int32(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = Int64(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = UInt(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = UInt8(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = UInt16(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = UInt32(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = UInt64(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: Float.Type, forKey key: K) throws -> Float {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = Float(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: Double.Type, forKey key: K) throws -> Double {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        guard let result = Double(value) else {
            throw DecodingError.typeMismatch(
                type, .incompatible(with: value, for: key))
        }
        return result
    }

    func decode(_ type: String.Type, forKey key: K) throws -> String {
        guard let value = decoder.values[key.stringValue] else {
            throw DecodingError.keyNotFound(key, nil)
        }
        return value
    }

    func decode<T>(
        _ type: T.Type, forKey key: K
        ) throws -> T where T : Decodable {
        fatalError("unsupported")
    }

    func nestedContainer<NestedKey>(
        keyedBy type: NestedKey.Type, forKey key: K
        ) throws -> KeyedDecodingContainer<NestedKey> {
        fatalError("unsupported")
    }

    func nestedUnkeyedContainer(
        forKey key: K
        ) throws -> UnkeyedDecodingContainer {
        fatalError("unsupported")
    }

    func superDecoder() throws -> Decoder {
        return decoder
    }

    func superDecoder(forKey key: K) throws -> Decoder {
        fatalError("unsupported")
    }
}

struct KeyValueSingleValueDecodingContainer: SingleValueDecodingContainer {
    var codingPath: [CodingKey] {
        return []
    }

    let decoder: KeyValueDecoder
    init(_ decoder: KeyValueDecoder) {
        self.decoder = decoder
    }

    func decodeNil() -> Bool {
        return decoder.values.count == 0
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        guard let value = decoder.values["boolean"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = Bool(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: Int.Type) throws -> Int {
        guard let value = decoder.values["integer"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = Int(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        guard let value = decoder.values["integer"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = Int8(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        guard let value = decoder.values["integer"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = Int16(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        guard let value = decoder.values["integer"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = Int32(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        guard let value = decoder.values["integer"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = Int64(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        guard let value = decoder.values["unsigned"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = UInt(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let value = decoder.values["unsigned"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = UInt8(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let value = decoder.values["unsigned"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = UInt16(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let value = decoder.values["unsigned"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = UInt32(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let value = decoder.values["unsigned"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = UInt64(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: Float.Type) throws -> Float {
        guard let value = decoder.values["float"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = Float(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: Double.Type) throws -> Double {
        guard let value = decoder.values["double"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        guard let result = Double(value) else {
            throw DecodingError.typeMismatch(type, .incompatible(with: value))
        }
        return result
    }

    func decode(_ type: String.Type) throws -> String {
        guard let value = decoder.values["string"] else {
            throw DecodingError.valueNotFound(type, nil)
        }
        return value
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        fatalError("unsupported")
    }
}
