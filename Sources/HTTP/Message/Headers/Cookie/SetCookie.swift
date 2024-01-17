import struct Foundation.Date
import struct Foundation.TimeZone
import class Foundation.DateFormatter

public struct SetCookie: Equatable {
    public var cookie: Cookie
    public var domain: String?
    public var path: String?
    public var expires: Date?
    public var maxAge: Int?
    public var sameSite: String?
    public var secure: Bool?
    public var httpOnly: Bool?

    public init(
        cookie: Cookie,
        domain: String? = nil,
        path: String? = nil,
        expires: Date? = nil,
        maxAge: Int? = nil,
        sameSite: String? = nil,
        secure: Bool? = nil,
        httpOnly: Bool? = nil
    ) {
        self.cookie = cookie
        self.domain = domain
        self.path = path
        self.expires = expires
        self.maxAge = maxAge
        self.sameSite = sameSite
        self.secure = secure
        self.httpOnly = httpOnly
    }
}

extension SetCookie {
    public init(
        name: String,
        value: String,
        domain: String? = nil,
        path: String? = nil,
        expires: Date? = nil,
        maxAge: Int? = nil,
        sameSite: String? = nil,
        secure: Bool? = nil,
        httpOnly: Bool? = nil
    ) {
        self.init(
            cookie: .init(name: name, value: value),
            domain: domain,
            path: path,
            expires: expires,
            maxAge: maxAge,
            sameSite: sameSite,
            secure: secure,
            httpOnly: httpOnly)
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

    var rawValue: [UInt8] {
        return [UInt8](Date.encodeFormatter.string(from: self).utf8)
    }
}
