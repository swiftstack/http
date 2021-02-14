import Stream
import struct Foundation.Date

extension Array where Element == Cookie {
    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        var cookies = [Cookie]()
        while true {
            cookies.append(try await Cookie.decode(from: stream))
            // should be separated by a semi-colon and a space ('; ')
            guard try await stream.consume(sequence: [.semicolon, .whitespace]) else {
                break
            }
        }
        return cookies
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        for i in 0..<count {
            try await self[i].encode(to: stream)
            if i + 1 < count {
                try await stream.write(.semicolon)
                try await stream.write(.whitespace)
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


    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        let name: String = try await stream.read(allowedBytes: .cookie) { bytes in
            guard bytes.count > 0 else {
                throw ParseError.invalidCookieHeader
            }
            return String(decoding: bytes, as: UTF8.self)
        }

        guard try await stream.consume(.equal) else {
            throw ParseError.invalidCookieHeader
        }

        let value = try await stream.read(allowedBytes: .cookie) { bytes in
            return String(decoding: bytes, as: UTF8.self)
        }

        return .init(name: name, value: value)
    }

    static func decode<T: StreamReader>(responseCookieFrom stream: T) async throws -> Self {
        var cookie = try await Self.decode(from: stream)

        while true {
            // should be separated by a semi-colon and a space ('; ')
            guard try await stream.consume(sequence: [.semicolon, .whitespace]) else {
                break
            }

            // attibute name
            let attributeHashValue = try await stream.read(allowedBytes: .token) { bytes in
                return bytes.lowercasedHashValue
            }

            func consume(_ byte: UInt8) async throws {
                guard try await stream.consume(byte) else {
                    throw ParseError.invalidCookieHeader
                }
            }
            // only in case if the attribute has a value
            func readValue(allowedBytes: AllowedBytes) async throws -> String {
                try await consume(.equal)
                return try await stream.read(allowedBytes: allowedBytes) { bytes in
                    return String(decoding: bytes, as: UTF8.self)
                }
            }

            // FIXME: validate values using value-specific rules
            switch attributeHashValue {
            // attributes with value
            case Bytes.domain.lowercasedHashValue:
                cookie.domain = try await readValue(allowedBytes: .cookie)

            case Bytes.path.lowercasedHashValue:
                cookie.path = try await readValue(allowedBytes: .cookie)

            case Bytes.expires.lowercasedHashValue:
                let dateString = try await readValue(allowedBytes: .cookie)
                guard let date = Date(from: dateString) else {
                    throw ParseError.invalidSetCookieHeader
                }
                cookie.expires = date

            case Bytes.maxAge.lowercasedHashValue:
                try await consume(.equal)
                guard let maxAge = try? await stream.parse(Int.self) else {
                    throw ParseError.invalidSetCookieHeader
                }
                cookie.maxAge = maxAge

            // single attributes
            case Bytes.httpOnly.lowercasedHashValue:
                cookie.httpOnly = true

            case Bytes.secure.lowercasedHashValue:
                cookie.secure = true

            default:
                throw ParseError.invalidSetCookieHeader
            }
        }

        return cookie
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        try await stream.write(name)
        try await stream.write(.equal)
        try await stream.write(value)

        if let domain = self.domain {
            try await stream.write(.semicolon)
            try await stream.write(.whitespace)
            try await stream.write(Bytes.domain)
            try await stream.write(.equal)
            try await stream.write(domain)
        }
        if let path = self.path {
            try await stream.write(.semicolon)
            try await stream.write(.whitespace)
            try await stream.write(Bytes.path)
            try await stream.write(.equal)
            try await stream.write(path)
        }
        if let expires = self.expires {
            try await stream.write(.semicolon)
            try await stream.write(.whitespace)
            try await stream.write(Bytes.expires)
            try await stream.write(.equal)
            try await stream.write(expires.rawValue)
        }
        if let maxAge = self.maxAge {
            try await stream.write(.semicolon)
            try await stream.write(.whitespace)
            try await stream.write(Bytes.maxAge)
            try await stream.write(.equal)
            try await stream.write(String(describing: maxAge))
        }
        if self.secure == true {
            try await stream.write(.semicolon)
            try await stream.write(.whitespace)
            try await stream.write(Bytes.secure)
        }
        if self.httpOnly == true {
            try await stream.write(.semicolon)
            try await stream.write(.whitespace)
            try await stream.write(Bytes.httpOnly)
        }
    }
}
