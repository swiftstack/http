import struct Foundation.URL
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

extension URL {
    public init(_ url: String) throws {
        guard let url = Foundation.URL(string: url) else {
            throw HTTPError.invalidURL
        }

        if let scheme = url.scheme {
            self.scheme = Scheme(rawValue: scheme)
        }

        self.host = url.host
        self.port = url.port
        switch url.path {
        case "": self.path = "/"
        default: self.path = url.path
        }
        self.fragment = url.fragment

        if let query = url.query {
            self.query = Query(from: query)
        } else {
            self.query = [:]
        }
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

extension URL {
    init(from buffer: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        var endIndex = buffer.endIndex
        if let index = buffer.index(of: .hash) {
            // FIXME: validate using url rules
            guard let fragment =
                String(validating: buffer[(index+1)...], as: .text) else {
                    throw HTTPError.invalidURL
            }
            self.fragment = fragment
            endIndex = index
        } else {
            self.fragment = nil
        }

        if let index = buffer[..<endIndex].index(of: .questionMark) {
            // FIXME: validate using url rules
            self.query = try Query(from: buffer[(index+1)..<endIndex])
            endIndex = index
        } else {
            self.query = [:]
        }

        // FIXME: validate using url rules
        guard let path =
            String(validating: buffer[..<endIndex], as: .text) else {
                throw HTTPError.invalidURL
        }
        self.path = path
    }

    func encode(to buffer: inout [UInt8]) {
        buffer.append(contentsOf: [UInt8](path.utf8))
        if query.values.count > 0 {
            buffer.append(.questionMark)
            query.encode(to: &buffer)
        }
        if let fragment = fragment {
            buffer.append(.hash)
            buffer.append(contentsOf: fragment.utf8)
        }
    }
}

extension URL.Query {
    public init(from string: String) {
        var values =  [String : String]()
        for pair in string.components(separatedBy: "&") {
            if let index = pair.index(of: "=") {
                let name = pair[..<index]
                let valueIndex = pair.index(after: index)
                let value = pair[valueIndex...]
                if let decodedName = String(name).removingPercentEncoding,
                    let decodedValue = String(value).removingPercentEncoding {
                    values[decodedName] = decodedValue
                }
            }
        }
        self.values = values
    }

    public init(from bytes: [UInt8]) throws {
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        try self.init(from: buffer[...])
    }

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        var values =  [String : String]()

        var startIndex = bytes.startIndex
        var endIndex = startIndex
        while startIndex < bytes.endIndex {
            guard let equalIndex =
                bytes.index(of: .equal, offset: startIndex) else {
                    throw HTTPError.invalidURL
            }
            // FIXME: validate using url rules
            guard let name =
                String(validating: bytes[startIndex..<equalIndex], as: .text)?
                    .removingPercentEncoding else {
                        throw HTTPError.invalidURL
            }

            startIndex = equalIndex + 1
            guard startIndex < bytes.endIndex else {
                throw HTTPError.invalidURL
            }

            endIndex = bytes.index(of: .ampersand, offset: startIndex)
                ?? bytes.endIndex
            // FIXME: validate using url rules
            guard let value =
                String(validating: bytes[startIndex..<endIndex], as: .text)?
                    .removingPercentEncoding else {
                        throw HTTPError.invalidURL
            }

            values[name] = value
            startIndex = endIndex + 1
        }

        self.values = values
    }

    public func encode(to buffer: inout [UInt8]) {
        let queryString = values
            .map({ "\($0.key)=\($0.value)" })
            .joined(separator: "&")
            .addingPercentEncoding(
                withAllowedCharacters: CharacterSet.urlQueryAllowed)
            ?? ""
        buffer.append(contentsOf: queryString.utf8)
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
