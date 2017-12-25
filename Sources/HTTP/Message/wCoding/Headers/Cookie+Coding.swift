import Stream

extension Array where Element == Cookie {
    init<T: UnsafeStreamReader>(from stream: T) throws {
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
    init?<T: UnsafeStreamReader>(from stream: T) throws {
        var buffer = try stream.read(allowedBytes: .cookie)
        guard buffer.count > 0 else {
            return nil
        }
        self.name = String(decoding: buffer, as: UTF8.self)

        guard try stream.consume(.equal) else {
            throw ParseError.invalidCookieHeader
        }

        buffer = try stream.read(allowedBytes: .cookie)
        self.value = String(decoding: buffer, as: UTF8.self)
    }

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        try stream.write(name)
        try stream.write(.equal)
        try stream.write(value)
    }
}
