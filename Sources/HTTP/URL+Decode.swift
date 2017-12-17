import struct Foundation.URL

extension URL.Scheme {
    static let httpBytes = [UInt8]("http".utf8)
    static let httpsBytes = [UInt8]("https".utf8)

    init?<T: RandomAccessCollection>(from bytes: T)
        where T.Element == UInt8, T.Index == Int {
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
        self.query = [:]

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
            let path = String(decoding: pathSlice, as: UTF8.self)
            guard let decodedPath = path.removingPercentEncoding else {
                throw Error.invalidPath
            }
            self.path = decodedPath
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
            let querySlice = bytes[index..<queryEndIndex]
            guard let query = Query(from: querySlice) else {
                throw Error.invalidQuery
            }
            self.query = query
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
    public init?<T: RandomAccessCollection>(from bytes: T)
        where T.Element == UInt8, T.Index == Int {
        var values =  [String : String]()
        for pair in bytes.split(separator: .ampersand) {
            if let index = pair.index(of: .equal) {
                let name = String(decoding: pair[..<index], as: UTF8.self)
                let valueIndex = index + 1
                guard valueIndex < bytes.endIndex else {
                    return nil
                }
                let value = String(decoding: pair[valueIndex...], as: UTF8.self)
                if let decodedName = name.removingPercentEncoding,
                    let decodedValue = value.removingPercentEncoding {
                    values[decodedName] = decodedValue
                }
            }
        }
        self.values = values
    }

    public init?(string: String) {
        var values =  [String : String]()
        for pair in string.components(separatedBy: "&") {
            if let index = pair.index(of: "=") {
                let name = pair[..<index]
                let valueIndex = pair.index(after: index)
                guard valueIndex < pair.endIndex else {
                    return nil
                }
                let value = pair[valueIndex...]
                if let decodedName = String(name).removingPercentEncoding,
                    let decodedValue = String(value).removingPercentEncoding {
                    values[decodedName] = decodedValue
                }
            }
        }
        self.values = values
    }
}

// Fast decode

extension URL {
    init<T: RandomAccessCollection>(escaped bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
        self.scheme = nil
        self.host = nil

        var endIndex = bytes.endIndex
        if let index = bytes.index(of: .hash) {
            // FIXME: validate using url rules
            guard let fragment =
                String(validating: bytes[(index+1)...], as: .text)?
                    .removingPercentEncoding else {
                        throw HTTPError.invalidURL
            }
            self.fragment = fragment
            endIndex = index
        } else {
            self.fragment = nil
        }

        if let index = bytes[..<endIndex].index(of: .questionMark) {
            // FIXME: validate using url rules
            self.query = try Query(escaped: bytes[(index+1)..<endIndex])
            endIndex = index
        } else {
            self.query = [:]
        }

        // FIXME: validate using url rules
        guard let path = String(validating: bytes[..<endIndex], as: .text)?
            .removingPercentEncoding else {
                throw HTTPError.invalidURL
        }
        self.path = path
    }
}

extension URL.Host {
    static func parsePort<T: RandomAccessCollection>(_ bytes: T) -> Int?
        where T.Element == UInt8, T.Index == Int {
        var port = 0
        for byte in bytes {
            guard byte >= .zero && byte <= .nine else {
                return nil
            }
            port *= 10
            port += Int(byte - .zero)
        }
        guard port > 0 else {
            return nil
        }
        return port
    }

    init?<T: RandomAccessCollection>(escaped bytes: T)
        where T.Element == UInt8, T.Index == Int {
        var addressEndIndex = bytes.endIndex
        if let colonIndex = bytes.index(of: .colon) {
            addressEndIndex = colonIndex
            let portIndex = colonIndex + 1
            self.port = URL.Host.parsePort(bytes[portIndex...])
        } else {
            self.port = nil
        }
        guard let address = String(
            validating: bytes[..<addressEndIndex], as: .text) else {
                return nil
        }
        self.address = Punycode.decode(domain: address)
    }
}


extension URL.Query {
    public init<T: RandomAccessCollection>(escaped bytes: T) throws
        where T.Element == UInt8, T.Index == Int {
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
}
