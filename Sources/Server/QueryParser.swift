import Foundation

public struct QueryParser {
    public static func parse(urlEncoded query: String) -> [String : Any] {
        var values =  [String : Any]()
        let pairs = query.components(separatedBy: "&")
        for pair in pairs {
            if let index = pair.characters.index(of: "=") {
                let name = pair.characters.prefix(upTo: index)
                let value = pair.characters.suffix(from: pair.characters.index(after: index))
                if let decodedName = String(name).removingPercentEncoding,
                    let decodedValue = String(value).removingPercentEncoding {
                    values[decodedName] = decodedValue
                }
            }
        }
        return values
    }

    public static func parse(json body: [UInt8]) -> [String : Any] {
        guard let json =
            try? JSONSerialization.jsonObject(with: Data(bytes: body)) else {
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
