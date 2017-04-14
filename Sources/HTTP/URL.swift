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
    public var query: String?
    public var scheme: Scheme?

    public init(
        host: String? = nil,
        port: Int? = nil,
        path: String,
        query: String? = nil,
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
        self.query = url.query
        if let scheme = url.scheme {
            self.scheme = Scheme(rawValue: scheme)
        }
    }
}

extension URL {
    static func encode(values: [String : String]) -> String {
        // FIXME: speedup
        let queryString = values.map({ "\($0)=\($1)" }).joined(separator: "&")
        let encodedQuery = queryString.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        return encodedQuery
    }
}

extension URL {
    var bytes: [UInt8] {
        var bytes = [UInt8]()
        bytes.append(contentsOf: [UInt8](path.utf8))
        if let query = query {
            bytes.append(Character.questionMark)
            bytes.append(contentsOf: [UInt8](query.utf8))
        }
        return bytes
    }
}

extension URL {
    init(from buffer: UnsafeRawBufferPointer) {
        if let index = buffer.index(of: Character.questionMark) {
            self.path = String(buffer: buffer.prefix(upTo: index))
            self.query = String(buffer: buffer.suffix(from: index + 1))
        } else {
            self.path = String(buffer: buffer)
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
