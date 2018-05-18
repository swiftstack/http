import Stream

extension URL.Scheme {
    static let httpBytes = [UInt8]("http".utf8)
    static let httpsBytes = [UInt8]("https".utf8)

    init?<T: RandomAccessCollection>(from bytes: T)
        where T.Element == UInt8, T.Index == Int
    {
        switch bytes {
        case _ where bytes.elementsEqual(URL.Scheme.httpBytes): self = .http
        case _ where bytes.elementsEqual(URL.Scheme.httpsBytes): self = .https
        default: return nil
        }
    }
}

extension URL {
    enum State {
        case scheme
        case domain
        case path
        case query
        case fragment
    }

    enum Error: Swift.Error {
        case invalidScheme
        case invalidPort
        case invalidPath
        case invalidQuery
    }

    public init(_ url: String) throws {
        self.scheme = nil
        self.host = nil
        self.fragment = nil

        let bytes = [UInt8](url.utf8)
        var index = bytes.startIndex

        var state: State = .scheme
        self.path = "/"
        self.query = nil

        func isValidDomainASCII(_ byte: UInt8) -> Bool {
            switch byte {
            case 45...46: return true
            case 48...57: return true
            case 65...90: return true
            case 97...122: return true
            default: return false
            }
        }

        func isDigit(_ byte: UInt8) -> Bool {
            return byte >= .zero && byte <= .nine
        }

        func parseScheme() throws {
            guard let slashIndex = bytes.index(of: .slash) else {
                return
            }
            guard slashIndex > 1,
                slashIndex + 1 < bytes.endIndex,
                bytes[slashIndex-1] == .colon,
                bytes[slashIndex+1] == .slash else {
                    return
            }
            guard let scheme = Scheme(from: bytes[...(slashIndex-2)]) else {
                throw Error.invalidScheme
            }
            self.scheme = scheme
            index = slashIndex + 2
        }

        func parseDomain() throws {
            guard isValidDomainASCII(bytes[index]) else {
                return
            }

            let domainEndIndex = bytes[index...].index(where: {
                !isValidDomainASCII($0)
            }) ?? bytes.endIndex

            let slice = bytes[index..<domainEndIndex]
            index = domainEndIndex

            let domain = String(decoding: slice, as: UTF8.self)
            var port: Int? = nil

            if index < bytes.endIndex && bytes[index] == .colon {
                index += 1
                port = try parsePort()
            }
            self.host = Host(address: domain, port: port)
        }

        func parsePort() throws -> Int {
            var port = 0
            while index < bytes.endIndex && isDigit(bytes[index]) {
                port *= 10
                port += Int(bytes[index] - .zero)
                index += 1
            }
            guard port > 0 else {
                throw Error.invalidPort
            }
            return port
        }

        func parsePath() throws {
            guard bytes[index] == .slash else {
                return
            }
            let pathEndIndex = bytes[index...].index(where: {
                $0 == .questionMark || $0 == .hash
            }) ?? bytes.endIndex

            var pathSlice = bytes[index..<pathEndIndex]
            if pathSlice.count > 1 && pathSlice.last == .slash {
                pathSlice = pathSlice.dropLast()
            }
            self.path = try String(removingPercentEncoding: pathSlice)
            index = pathEndIndex
        }

        func parseQuery() throws {
            guard bytes[index] == .questionMark else {
                return
            }
            index += 1
            let queryEndIndex = bytes[index...].index(where: {
                $0 == .hash
            }) ?? bytes.endIndex
            self.query = try Query(from: bytes[index..<queryEndIndex])
            index = queryEndIndex
        }

        func parseFragment() throws {
            guard bytes[index] == .hash else {
                return
            }
            index += 1
            self.fragment = String(decoding: bytes[index...], as: UTF8.self)
        }

        while index < bytes.endIndex {
            switch state {
            case .scheme:
                try parseScheme()
                state = .domain
            case .domain:
                try parseDomain()
                state = .path
            case .path:
                try parsePath()
                state = .query
            case .query:
                try parseQuery()
                state = .fragment
            case .fragment:
                try parseFragment()
                return
            }
        }
    }
}

extension URL.Query {
    public init(string: String) throws {
        var values =  [String : String]()
        for pair in string.components(separatedBy: "&") {
            if let index = pair.index(of: "=") {
                let valueIndex = pair.index(after: index)
                guard valueIndex < pair.endIndex else {
                    throw URL.Error.invalidQuery
                }
                let name = try URL.decode(pair[..<index])
                let value = try URL.decode(pair[valueIndex...])
                values[name] = value
            }
        }
        self.values = values
    }

    // Used for decoding formEncoded body. TODO: use stream
    public init<T: RandomAccessCollection>(from bytes: T) throws
        where T.Element == UInt8, T.Index == Int
    {
        var values =  [String : String]()
        for pair in bytes.split(separator: .ampersand) {
            if var index = pair.index(of: .equal) {
                let name = try String(removingPercentEncoding: pair[..<index])
                index += 1
                guard index < bytes.endIndex else {
                    throw URL.Error.invalidQuery
                }
                let value = try String(removingPercentEncoding: pair[index...])
                values[name] = value
            }
        }
        self.values = values
    }
}

// Decode from Stream

extension URL {
    init<T: StreamReader>(from stream: T) throws {
        self.scheme = nil
        self.host = nil

        self.path = try stream.read(allowedBytes: .path) { bytes in
            return try String(removingPercentEncoding: bytes)
        }

        switch try stream.consume(.questionMark) {
        case true: self.query = try Query(from: stream)
        case false: self.query = nil
        }

        switch try stream.consume(.hash) {
        case true:
            self.fragment = try stream.read(allowedBytes: .fragment) { bytes in
                return try String(removingPercentEncoding: bytes)
            }
        default:
            self.fragment = nil
        }
    }
}

extension URL.Host {
    init<T: StreamReader>(from stream: T) throws {
        self.address = try stream.read(allowedBytes: .domain) { bytes in
            guard bytes.count > 0 else {
                throw ParseError.invalidHost
            }
            switch Punycode.isEncoded(domain: bytes) {
            case true: return Punycode.decode(domain: bytes)
            case false: return String(decoding: bytes, as: UTF8.self)
            }
        }

        switch try stream.consume(.colon) {
        case true:
            guard let port = try Int(from: stream) else {
                throw ParseError.invalidPort
            }
            self.port = port
        default:
            self.port = nil
        }
    }
}

extension URL.Query {
    init<T: StreamReader>(from stream: T) throws {
        var values =  [String : String]()

        while true {
            let name = try stream.read(allowedBytes: .queryPart) { bytes in
                return try String(removingPercentEncoding: bytes)
            }
            guard try stream.consume(.equal) else {
                throw ParseError.invalidURL
            }
            let value = try stream.read(allowedBytes: .queryPart) { bytes in
                return try String(removingPercentEncoding: bytes)
            }

            values[name] = value

            guard try stream.consume(.ampersand) else {
                break
            }
        }

        self.values = values
    }
}

extension String {
    init<T: RandomAccessCollection>(removingPercentEncoding bytes: T) throws
        where T.Element == UInt8, T.Index == Int
    {
        switch bytes.contains(.percent) {
        case false:
            self = String(decoding: bytes, as: UTF8.self)
        case true:
            let decoded = try URL.decode(bytes)
            self = String(decoding: decoded, as: UTF8.self)
        }
    }
}
