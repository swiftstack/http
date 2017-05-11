import Foundation

// TODO: rewrite or drop in favor of JSONEncoder() from swift 4

public struct JSON {
    public static func encode(_ object: Any) throws -> [UInt8] {
        let jsonObject: Any
        switch object {
        case let value as Int: jsonObject = value
        case let value as UInt: jsonObject = value
        case let value as String: jsonObject = value
        case let value as [Any]: jsonObject = value
        case let value as [String : Any]: jsonObject = value
        default: jsonObject = try encode(object: object)
        }
        return [UInt8](try JSONSerialization.data(withJSONObject: jsonObject))
    }

    fileprivate static func encode(object: Any) throws -> [String : Any] {
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
                case let value as [Any]: dictionary[name] = value
                case let value as [String : Any]: dictionary[name] = value
                default: dictionary[name] = try encode(object: child.value)
                }
            }
        }
        return dictionary
    }

    public static func decode(_ bytes: [UInt8]) -> [String : Any] {
        guard let json =
            try? JSONSerialization.jsonObject(with: Data(bytes: bytes)) else {
                return [:]
        }

        guard let values = json as? [String : Any] else {
            return [:]
        }

        #if os(Linux)
            return values
        #else
            // critical for reflection
            return convertObjectiveCTypes(values)
        #endif
    }

    #if !os(Linux)
    static func convertObjectiveCTypes(
        _ dictionary: [String : Any]
        ) -> [String : Any] {
        var values =  [String : Any]()

        for (key, value) in dictionary {
            if let value = value as? NSNumber {
                switch CFNumberGetType(value) {
                case .charType:
                    values[key] = value as! Bool
                case .sInt8Type,
                     .sInt16Type,
                     .sInt32Type,
                     .sInt64Type,
                     .shortType,
                     .intType,
                     .longType,
                     .longLongType,
                     .cfIndexType,
                     .nsIntegerType:
                    values[key] = value as! Int
                case .float32Type,
                     .float64Type,
                     .floatType,
                     .doubleType,
                     .cgFloatType:
                    values[key] = value as! Double
                }
            } else if let value = value as? String {
                values[key] = value
            } else if let value = value as? [String : Any] {
                values[key] = convertObjectiveCTypes(value)
            } else {
                return [:]
            }
        }

        return values
    }
    #endif
}
