import Stream
import struct Foundation.Date

extension Array where Element == Cookie {
    init<T: UnsafeStreamReader>(from stream: T) throws {
        var cookies = [Cookie]()
        while true {
            cookies.append(try Cookie(from: stream))
            // should be separated by a semi-colon and a space ('; ')
            guard try stream.consume(sequence: [.semicolon, .whitespace]) else {
                break
            }
        }
        self = cookies
    }

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        for i in 0..<count {
            try self[i].encode(to: stream)
            if i + 1 < count {
                try stream.write(.semicolon)
                try stream.write(.whitespace)
            }
        }
    }
}

extension Cookie {
    struct Bytes {
        static let expires = ASCII("Expires")
        static let maxAge = ASCII("Max-Age")
        static let domain = ASCII("Domain")
        static let path = ASCII("Path")

        static let httpOnly = ASCII("HttpOnly")
        static let secure = ASCII("Secure")
    }


    init<T: UnsafeStreamReader>(from stream: T) throws {
        var buffer = try stream.read(allowedBytes: .cookie)
        guard buffer.count > 0 else {
            throw ParseError.invalidCookieHeader
        }
        self.name = String(decoding: buffer, as: UTF8.self)

        guard try stream.consume(.equal) else {
            throw ParseError.invalidCookieHeader
        }

        buffer = try stream.read(allowedBytes: .cookie)
        self.value = String(decoding: buffer, as: UTF8.self)
    }

    init<T: UnsafeStreamReader>(responseCookieFrom stream: T) throws {
        try self.init(from: stream)

        while true {
            // should be separated by a semi-colon and a space ('; ')
            guard try stream.consume(sequence: [.semicolon, .whitespace]) else {
                break
            }

            // attibute name
            var buffer = try stream.read(allowedBytes: .token)
            let attributeHashValue = buffer.lowercasedHashValue

            func consumeEquals() throws {
                // =
                guard try stream.consume(.equal) else {
                    throw ParseError.invalidCookieHeader
                }
            }
            // only in case if the attribute has a value
            func readValue(allowedBytes: AllowedBytes) throws -> String {
                try consumeEquals()
                // value
                buffer = try stream.read(allowedBytes: allowedBytes)
                return String(decoding: buffer, as: UTF8.self)
            }

            // FIXME: validate values using value-specific rules
            switch attributeHashValue {
            // attributes with value
            case Bytes.domain.lowercasedHashValue:
                self.domain = try readValue(allowedBytes: .cookie)

            case Bytes.path.lowercasedHashValue:
                self.path = try readValue(allowedBytes: .cookie)

            case Bytes.expires.lowercasedHashValue:
                let dateString = try readValue(allowedBytes: .cookie)
                guard let date = Date(from: dateString) else {
                    throw ParseError.invalidSetCookieHeader
                }
                self.expires = date

            case Bytes.maxAge.lowercasedHashValue:
                try consumeEquals()
                guard let maxAge = try? Int(from: stream) else {
                    throw ParseError.invalidSetCookieHeader
                }
                self.maxAge = maxAge

            // single attributes
            case Bytes.httpOnly.lowercasedHashValue:
                self.httpOnly = true

            case Bytes.secure.lowercasedHashValue:
                self.secure = true

            default:
                throw ParseError.invalidSetCookieHeader
            }
        }
    }

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        try stream.write(name)
        try stream.write(.equal)
        try stream.write(value)

        if let domain = self.domain {
            try stream.write(.semicolon)
            try stream.write(.whitespace)
            try stream.write(Bytes.domain)
            try stream.write(.equal)
            try stream.write(domain)
        }
        if let path = self.path {
            try stream.write(.semicolon)
            try stream.write(.whitespace)
            try stream.write(Bytes.path)
            try stream.write(.equal)
            try stream.write(path)
        }
        if let expires = self.expires {
            try stream.write(.semicolon)
            try stream.write(.whitespace)
            try stream.write(Bytes.expires)
            try stream.write(.equal)
            try stream.write(expires.rawValue)
        }
        if let maxAge = self.maxAge {
            try stream.write(.semicolon)
            try stream.write(.whitespace)
            try stream.write(Bytes.maxAge)
            try stream.write(.equal)
            try stream.write(String(describing: maxAge))
        }
        if self.secure == true {
            try stream.write(.semicolon)
            try stream.write(.whitespace)
            try stream.write(Bytes.secure)
        }
        if self.httpOnly == true {
            try stream.write(.semicolon)
            try stream.write(.whitespace)
            try stream.write(Bytes.httpOnly)
        }
    }
}
