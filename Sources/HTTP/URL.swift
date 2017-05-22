import struct Foundation.URL
import struct Foundation.CharacterSet

public struct URL {
    public enum Scheme: String {
        case http
        case https
    }
    public var host: String?
    public var port: Int?
    public var path: String
    public var query: [String : String]
    public var scheme: Scheme?

    public init(
        host: String? = nil,
        port: Int? = nil,
        path: String,
        query: [String : String] = [:],
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
            self.query = URL.decode(urlEncoded: query)
        } else {
            self.query = [:]
        }
        if let scheme = url.scheme {
            self.scheme = Scheme(rawValue: scheme)
        }
    }
}

extension URL {
    static func encode(values: [String : String]) -> String {
        // TODO: optimize
        let queryString = values.map({ "\($0.key)=\($0.value)" })
            .joined(separator: "&")
        let encodedQuery = queryString.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        return encodedQuery
    }

    public static func decode(urlEncoded query: String) -> [String : String] {
        var values =  [String : String]()
        let pairs = query.components(separatedBy: "&")
        for pair in pairs {
            if let index = pair.characters.index(of: "=") {
                let name = pair.characters[..<index]
                let valueIndex = pair.characters.index(after: index)
                let value = pair.characters[valueIndex...]
                if let decodedName = String(name).removingPercentEncoding,
                    let decodedValue = String(value).removingPercentEncoding {
                    values[decodedName] = decodedValue
                }
            }
        }
        return values
    }
}

extension URL {
    init(from buffer: RandomAccessSlice<UnsafeRawBufferPointer>) {
        if let index = buffer.index(of: Character.questionMark) {
            self.path = String(buffer: buffer[..<index])
            // TODO: optimize
            let queryIndex = index + 1
            let query = String(buffer: buffer[queryIndex...])
            self.query = URL.decode(urlEncoded: query)
        } else {
            self.path = String(buffer: buffer)
            self.query = [:]
        }
    }

    func encode(to buffer: inout [UInt8]) {
        buffer.append(contentsOf: [UInt8](path.utf8))
        if query.count > 0 {
            buffer.append(Character.questionMark)
            // TODO: optimize
            buffer.append(contentsOf: [UInt8](URL.encode(values: query).utf8))
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
