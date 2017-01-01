import Foundation

public struct QueryParamMatcher {
    public init () {}
    public func values(from query: String) -> [String : String] {
        var values =  [String : String]()
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
}
