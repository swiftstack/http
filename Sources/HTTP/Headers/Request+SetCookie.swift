import Stream

import struct Foundation.Date
import struct Foundation.TimeZone
import class Foundation.DateFormatter

extension Response {
    public struct SetCookie {
        public var cookie: Cookie
        public var domain: String? = nil
        public var path: String? = nil
        public var expires: Date? = nil
        public var maxAge: Int? = nil
        public var secure: Bool? = nil
        public var httpOnly: Bool? = nil

        public init(
            _ cookie: Cookie,
            domain: String? = nil,
            path: String? = nil,
            expires: Date? = nil,
            maxAge: Int? = nil,
            secure: Bool? = nil,
            httpOnly: Bool? = nil
        ) {
            self.cookie = cookie
            self.domain = domain
            self.path = path
            self.expires = expires
            self.maxAge = maxAge
            self.secure = secure
            self.httpOnly = httpOnly
        }
    }
}

extension Response.SetCookie: Equatable {
    public typealias SetCookie = Response.SetCookie
    public static func ==(lhs: SetCookie, rhs: SetCookie) -> Bool {
        return lhs.cookie == rhs.cookie &&
            lhs.domain == rhs.domain &&
            lhs.path == rhs.path &&
            lhs.expires == rhs.expires &&
            lhs.maxAge == rhs.maxAge &&
            lhs.secure == rhs.secure &&
            lhs.httpOnly == rhs.httpOnly
    }
}

extension Response.SetCookie {
    struct Bytes {
        static let expires = ASCII("Expires")
        static let maxAge = ASCII("Max-Age")
        static let domain = ASCII("Domain")
        static let path = ASCII("Path")

        static let httpOnly = ASCII("HttpOnly")
        static let secure = ASCII("Secure")
    }

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        guard let cookie = try Cookie(from: stream) else {
            throw HTTPError.invalidCookieHeader
        }
        self.cookie = cookie

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
                    throw HTTPError.invalidCookieHeader
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
                        throw HTTPError.invalidSetCookieHeader
                }
                self.expires = date

            case Bytes.maxAge.lowercasedHashValue:
                try consumeEquals()
                guard let maxAge = try? Int(from: stream) else {
                    throw HTTPError.invalidSetCookieHeader
                }
                self.maxAge = maxAge

            // single attributes
            case Bytes.httpOnly.lowercasedHashValue:
                self.httpOnly = true

            case Bytes.secure.lowercasedHashValue:
                self.secure = true

            default:
                throw HTTPError.invalidSetCookieHeader
            }
        }
    }

    func encode(to buffer: inout [UInt8]) {
        cookie.encode(to: &buffer)
        if let domain = self.domain {
            buffer.append(.semicolon)
            buffer.append(.whitespace)
            buffer.append(contentsOf: Bytes.domain)
            buffer.append(.equal)
            buffer.append(contentsOf: domain.utf8)
        }
        if let path = self.path {
            buffer.append(.semicolon)
            buffer.append(.whitespace)
            buffer.append(contentsOf: Bytes.path)
            buffer.append(.equal)
            buffer.append(contentsOf: path.utf8)
        }
        if let expires = self.expires {
            buffer.append(.semicolon)
            buffer.append(.whitespace)
            buffer.append(contentsOf: Bytes.expires)
            buffer.append(.equal)
            expires.encode(to: &buffer)
        }
        if let maxAge = self.maxAge {
            buffer.append(.semicolon)
            buffer.append(.whitespace)
            buffer.append(contentsOf: Bytes.maxAge)
            buffer.append(.equal)
            buffer.append(contentsOf: String(describing: maxAge).utf8)
        }
        if self.secure == true {
            buffer.append(.semicolon)
            buffer.append(.whitespace)
            buffer.append(contentsOf: Bytes.secure)
        }
        if self.httpOnly == true {
            buffer.append(.semicolon)
            buffer.append(.whitespace)
            buffer.append(contentsOf: Bytes.httpOnly)
        }
    }
}

extension Date {
    static var decodeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "EEE, dd'-'MMM'-'yy HH:mm:ss z"
        return formatter
    }

    #if os(Linux)
    static var decodeFormatterLinuxBug: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        return formatter
    }
    #endif

    static var encodeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        return formatter
    }

    init?(from string: String) {
        guard let date = Date.decodeFormatter.date(from: string) else {
            #if os(Linux)
            if let date = Date.decodeFormatterLinuxBug.date(from: string) {
                self = date
                return
            }
            #endif
            return nil
        }
        self = date
    }

    func encode(to buffer: inout [UInt8]) {
        buffer.append(contentsOf: Date.encodeFormatter.string(from: self).utf8)
    }
}
