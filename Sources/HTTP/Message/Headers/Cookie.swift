import struct Foundation.Date
import struct Foundation.TimeZone
import class Foundation.DateFormatter

public struct Cookie: Equatable {
    public var name: String
    public var value: String
    public var domain: String? = nil
    public var path: String? = nil
    public var expires: Date? = nil
    public var maxAge: Int? = nil
    public var secure: Bool? = nil
    public var httpOnly: Bool? = nil

    public init(
        name: String,
        value: String,
        domain: String? = nil,
        path: String? = nil,
        expires: Date? = nil,
        maxAge: Int? = nil,
        secure: Bool? = nil,
        httpOnly: Bool? = nil)
    {
        self.name = name
        self.value = value
        self.domain = domain
        self.path = path
        self.expires = expires
        self.maxAge = maxAge
        self.secure = secure
        self.httpOnly = httpOnly
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
