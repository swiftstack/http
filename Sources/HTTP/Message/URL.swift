import struct Foundation.CharacterSet

public struct URL {
    public enum Scheme: String {
        case http
        case https
    }

    public struct Query: Equatable {
        public var values: [String : String]

        public init(values: [String : String]) {
            self.values = values
        }
    }

    public struct Host: Equatable {
        public let address: String
        public let port: Int?

        public init(address: String, port: Int? = nil) {
            self.address = address
            self.port = port
        }
    }

    public var scheme: Scheme?
    public var host: Host?
    public var path: String
    public var query: Query?
    public var fragment: String?

    public init(
        scheme: Scheme? = nil,
        host: Host? = nil,
        path: String,
        query: Query? = nil,
        fragment: String? = nil
    ) {
        self.host = host
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
        // all but fragment
        return lhs.scheme == rhs.scheme
            && lhs.host == rhs.host
            && lhs.path == rhs.path
            && lhs.query == rhs.query
    }

    public static func ==(lhs: URL, rhs: String) -> Bool {
        guard let rhs = try? URL(rhs) else {
            return false
        }
        return lhs == rhs
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        do {
            self = try URL(value)
        } catch {
            fatalError("invalid url: '\(error)'")
        }
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
            url.append(host.address)
            if let port = host.port {
                url.append(":")
                url.append(String(describing: port))
            }
        }
        url.append(path)
        if let query = query, query.values.count > 0 {
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
    }
}

extension URL.Host: CustomStringConvertible {
    public var description: String {
        guard let port = port else {
            return address
        }
        return "\(address):\(port)"
    }
}
