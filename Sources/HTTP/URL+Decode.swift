import Stream
import struct Foundation.URL

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

    public init(string: String) throws {
        var values =  [String : String]()
        for pair in string.components(separatedBy: "&") {
            if let index = pair.index(of: "=") {
                let valueIndex = pair.index(after: index)
                guard valueIndex < pair.endIndex else {
                    throw URL.Error.invalidQuery
                }
                let name = try URL.removePercentEncoding(pair[..<index])
                let value = try URL.removePercentEncoding(pair[valueIndex...])
                values[name] = value
            }
        }
        self.values = values
    }
}

// Fast decode

extension URL {
    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        let bytes = try stream.read(until: .whitespace)
        self.scheme = nil
        self.host = nil

        var endIndex = bytes.endIndex
        if let index = bytes.index(of: .hash) {
            // FIXME: validate using url rules
            let fragmentSlice = bytes[(index+1)...]
            self.fragment = try String(removingPercentEncoding: fragmentSlice)
            endIndex = index
        } else {
            self.fragment = nil
        }

        if let index = bytes[..<endIndex].index(of: .questionMark) {
            // FIXME: validate using url rules
            self.query = try Query(escaped: bytes[(index+1)..<endIndex])
            endIndex = index
        } else {
            self.query = nil
        }

        // FIXME: validate using url rules
        self.path = try String(removingPercentEncoding: bytes[..<endIndex])
    }
}

extension Set where Element == UInt8 {
    static let idnAllowed: Set<UInt8> = {
        return Set<UInt8>(ASCII(
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-."
        ))
    }()
}

let idnAllowed = AllowedBytes(byteSet: .idnAllowed)

extension URL.Host {
    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        let bytes = try stream.read(allowedBytes: idnAllowed)
        guard bytes.count > 0 else {
            throw HTTPError.invalidHost
        }
        if Punycode.isEncoded(domain: bytes) {
            self.address = Punycode.decode(domain: bytes)
        } else {
            self.address = String(decoding: bytes, as: UTF8.self)
        }

        guard let colon = try stream.peek(count: 1),
            colon.first! == .colon else {
                self.port = nil
                return
        }
        try stream.consume(count: 1)
        guard let port = try Int(from: stream) else {
            throw HTTPError.invalidPort
        }
        self.port = port
    }
}

extension URL.Query {
    public init<T: RandomAccessCollection>(escaped bytes: T) throws
        where T.Element == UInt8, T.Index == Int
    {
        var values =  [String : String]()

        var startIndex = bytes.startIndex
        while startIndex < bytes.endIndex {
            guard let equalIndex = bytes[startIndex...].index(of: .equal) else {
                throw HTTPError.invalidURL
            }
            let valueStartIndex = equalIndex + 1
            guard valueStartIndex < bytes.endIndex else {
                throw HTTPError.invalidURL
            }
            let valueEndIndex =
                bytes[valueStartIndex...].index(of: .ampersand) ??
                bytes.endIndex

            // FIXME: validate using url rules
            let nameSlice = bytes[startIndex..<equalIndex]
            // FIXME: validate using url rules
            let valueSlice = bytes[valueStartIndex..<valueEndIndex]

            let name = try String(removingPercentEncoding: nameSlice)
            let value = try String(removingPercentEncoding: valueSlice)
            values[name] = value

            startIndex = valueEndIndex + 1
        }

        self.values = values
    }
}

extension UInt8 {
    @inline(__always)
    func contained(in set: Set<UInt8>) -> Bool {
        return set.contains(self)
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
            let decoded = try URL.removePercentEncoding(bytes)
            self = String(decoding: decoded, as: UTF8.self)
        }
    }
}
