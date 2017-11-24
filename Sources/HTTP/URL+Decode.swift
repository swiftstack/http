import struct Foundation.URL

extension URL {
    public init(_ url: String) throws {
        guard let url = Foundation.URL(string: url) else {
            throw HTTPError.invalidURL
        }

        if let scheme = url.scheme {
            self.scheme = Scheme(rawValue: scheme)
        } else {
            self.scheme = nil
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

extension URL {
    init(from buffer: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        self.scheme = nil
        self.host = nil
        self.port = nil

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
}
