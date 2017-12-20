import Stream

public struct Cookie {
    let name: String
    let value: String

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension Cookie: Equatable {
    public static func ==(lhs: Cookie, rhs: Cookie) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }
}

extension Array where Element == Cookie {
    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        var cookies = [Cookie]()
        while true {
            guard let cookie = try Cookie(from: stream) else {
                break
            }
            cookies.append(cookie)
            // should be separated by a semi-colon and a space ('; ')
            guard try stream.consume(sequence: [.semicolon, .whitespace]) else {
                break
            }
        }
        self = cookies
    }

    func encode<T: OutputStream>(to stream: BufferedOutputStream<T>) throws {
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
    init?<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        var buffer = try stream.read(allowedBytes: .cookie)
        guard buffer.count > 0 else {
            return nil
        }
        self.name = String(decoding: buffer, as: UTF8.self)

        guard try stream.consume(.equal) else {
            throw HTTPError.invalidCookieHeader
        }

        buffer = try stream.read(allowedBytes: .cookie)
        self.value = String(decoding: buffer, as: UTF8.self)
    }

    func encode<T: OutputStream>(to stream: BufferedOutputStream<T>) throws {
        try stream.write(name)
        try stream.write(.equal)
        try stream.write(value)
    }
}
