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

    public var host: String?
    public var port: Int?
    public var path: String
    public var query: Query
    public var scheme: Scheme?

    public init(
        host: String? = nil,
        port: Int? = nil,
        path: String,
        query: Query = [:],
        scheme: Scheme? = nil
    ) {
        self.host = host
        self.port = port
        self.path = path
        self.query = query
        self.scheme = scheme
    }
}

extension URL {
    public init(_ url: String) throws {
        guard let url = Foundation.URL(string: url) else {
            throw HTTPError.invalidURL
        }
        self.host = url.host
        self.port = url.port
        self.path = url.path
        if let query = url.query {
            self.query = Query(from: query)
        } else {
            self.query = [:]
        }
        if let scheme = url.scheme {
            self.scheme = Scheme(rawValue: scheme)
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
                bytes.index(of: Character.equal, offset: startIndex) else {
                    throw HTTPError.invalidURL
            }
            guard let name = String(buffer: bytes[startIndex..<equalIndex])
                .removingPercentEncoding else {
                    throw HTTPError.invalidURL
            }

            startIndex = equalIndex + 1
            guard startIndex < bytes.endIndex else {
                throw HTTPError.invalidURL
            }

            endIndex = bytes.index(of: Character.equal, offset: startIndex)
                ?? bytes.endIndex
            guard let value = String(buffer: bytes[startIndex..<endIndex])
                .removingPercentEncoding else {
                    throw HTTPError.invalidURL
            }

            values[name] = value
            startIndex = endIndex
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

extension URL {
    init(from buffer: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        if let index = buffer.index(of: Character.questionMark) {
            self.path = String(buffer: buffer[..<index])
            let queryIndex = index + 1
            self.query = try Query(from: buffer[queryIndex...])
        } else {
            self.path = String(buffer: buffer)
            self.query = [:]
        }
    }

    func encode(to buffer: inout [UInt8]) {
        buffer.append(contentsOf: [UInt8](path.utf8))
        if query.values.count > 0 {
            buffer.append(Character.questionMark)
            query.encode(to: &buffer)
        }
    }
}

extension URL.Query: Equatable {
    public static func ==(lhs: URL.Query, rhs: URL.Query) -> Bool {
        return lhs.values == rhs.values
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

extension URL.Query: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        self.values = Dictionary(uniqueKeysWithValues: elements)
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
