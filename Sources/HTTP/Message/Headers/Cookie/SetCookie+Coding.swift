import Stream
import struct Foundation.Date

extension Array where Element == SetCookie {
    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        var cookies = [SetCookie]()
        while true {
            cookies.append(try await .decode(from: stream))
            // should be separated by a semi-colon and a space ('; ')
            guard
                try await stream.consume(sequence: [.semicolon, .whitespace])
            else {
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

extension SetCookie {
    struct Bytes {
        static let expires = ASCII("Expires")
        static let maxAge = ASCII("Max-Age")
        static let domain = ASCII("Domain")
        static let path = ASCII("Path")

        static let sameSite = ASCII("SameSite")
        static let httpOnly = ASCII("HttpOnly")
        static let secure = ASCII("Secure")
    }

    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        var cookie = try await SetCookie(cookie: .decode(from: stream))

        while true {
            // should be separated by a semi-colon and a space ('; ')
            guard
                try await stream.consume(sequence: [.semicolon, .whitespace])
            else {
                break
            }

            // attibute name
            let attributeHashValue =
                try await stream.read(allowedBytes: .token) { bytes in
                    return bytes.lowercasedHashValue
                }

            func consume(_ byte: UInt8) async throws {
                guard try await stream.consume(byte) else {
                    throw Error.invalidCookieHeader
                }
            }
            // only in case if the attribute has a value
            func readValue(allowedBytes: AllowedBytes) async throws -> String {
                try await consume(.equal)
                return try await stream.read(allowedBytes: allowedBytes) {
                    return String(decoding: $0, as: UTF8.self)
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
                    throw Error.invalidSetCookieHeader
                }
                cookie.expires = date

            case Bytes.maxAge.lowercasedHashValue:
                try await consume(.equal)
                guard let maxAge = try? await stream.parse(Int.self) else {
                    throw Error.invalidSetCookieHeader
                }
                cookie.maxAge = maxAge

            case Bytes.sameSite.lowercasedHashValue:
                cookie.sameSite = try await readValue(allowedBytes: .cookie)

            // single attributes
            case Bytes.httpOnly.lowercasedHashValue:
                cookie.httpOnly = true

            case Bytes.secure.lowercasedHashValue:
                cookie.secure = true

            default:
                throw Error.invalidSetCookieHeader
            }
        }

        return cookie
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        try await cookie.encode(to: stream)

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
        if let sameSite = self.sameSite {
            try await stream.write(.semicolon)
            try await stream.write(.whitespace)
            try await stream.write(Bytes.sameSite)
            try await stream.write(.equal)
            try await stream.write(sameSite)
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
