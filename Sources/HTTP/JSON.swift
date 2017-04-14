import class Foundation.JSONSerialization

struct JSON {
    static func serialize(_ object: Any) throws -> [UInt8] {
        let jsonObject: Any
        switch object {
        case let value as Int: jsonObject = value
        case let value as UInt: jsonObject = value
        case let value as String: jsonObject = value
        case let value as [String : Any]: jsonObject = value
        default: jsonObject = serialize(object: object)
        }
        return [UInt8](try JSONSerialization.data(withJSONObject: jsonObject))
    }

    fileprivate static func serialize(object: Any) -> [String : Any] {
        let mirror = Mirror(reflecting: object)
        var dictionary = [String : Any]()
        for child in mirror.children {
            if let name = child.label {
                switch child.value {
                case let value as String: dictionary[name] = value
                case let value as Int: dictionary[name] = value
                case let value as UInt: dictionary[name] = value
                case let value as Bool: dictionary[name] = value
                case let value as Double: dictionary[name] = value
                case let value as [String : String]: dictionary[name] = value
                default: continue
                }
            }
        }
        return dictionary
    }
}
