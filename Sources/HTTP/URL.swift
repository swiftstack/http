import struct Foundation.CharacterSet

public struct URL {
    public enum Scheme: String {
        case http
        case https
    }

    public struct Query {
        public var values: [String : String]
    }

    public var scheme: Scheme?
    public var host: String?
    public var port: Int?
    public var path: String
    public var query: Query
    public var fragment: String?

    public init(
        scheme: Scheme? = nil,
        host: String? = nil,
        port: Int? = nil,
        path: String,
        query: Query = [:],
        fragment: String? = nil
    ) {
        self.host = host
        self.port = port
        self.path = path
        self.query = query
        self.scheme = scheme
        self.fragment = fragment
    }
}

extension URL {
    public var absoluteString: String {
        return String(describing: self)
    }
}


extension URL.Query {
    public init(_ values: [String : String]) {
        self.values = values
    }

    public subscript(_ name: String) -> String? {
        get {
            return values[name]
        }
        set {
            values[name] = newValue
        }
    }
}

extension URL: Equatable {
    public static func ==(lhs: URL, rhs: URL) -> Bool {
        return lhs.path == rhs.path && lhs.query == rhs.query
    }

    public static func ==(lhs: URL, rhs: String) -> Bool {
        guard let rhs = try? URL(rhs) else {
            return false
        }
        return lhs == rhs
    }
}

extension URL.Query: Equatable {
    public static func ==(lhs: URL.Query, rhs: URL.Query) -> Bool {
        return lhs.values == rhs.values
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let url = try? URL(value) else {
            fatalError("invalid url: '\(value)'")
        }
        self = url
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension URL.Query: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        self.values = Dictionary(uniqueKeysWithValues: elements)
    }
}

extension URL: CustomStringConvertible {
    public var description: String {
        var url = ""
        if let scheme = self.scheme {
            url.append(scheme.rawValue)
            url.append("://")
        }
        if let host = self.host {
            url.append(host)
            if let port = port {
                url.append(":")
                url.append(String(describing: port))
            }
        }
        url.append(path)
        if query.values.count > 0 {
            url.append("?")
            url.append(String(describing: query))
        }
        if let fragment = self.fragment {
            url.append("#")
            url.append(fragment)
        }
        return url
    }
}

extension URL.Query: CustomStringConvertible {
    public var description: String {
        return values
            .map({ "\($0.key)=\($0.value)" })
            .joined(separator: "&")
            .addingPercentEncoding(
                withAllowedCharacters: CharacterSet.urlQueryAllowed)
            ?? ""
    }
}
