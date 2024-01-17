import Stream

extension Array where Element == Cookie {
    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        var cookies = [Cookie]()
        while true {
            cookies.append(try await Cookie.decode(from: stream))
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

extension Cookie {
    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        let name = try await stream.read(allowedBytes: .cookie) { bytes in
            guard bytes.count > 0 else {
                throw Error.invalidCookieHeader
            }
            return String(decoding: bytes, as: UTF8.self)
        }

        guard try await stream.consume(.equal) else {
            throw Error.invalidCookieHeader
        }

        let value = try await stream.read(allowedBytes: .cookieValue) { bytes in
            return String(decoding: bytes, as: UTF8.self)
        }

        return .init(name: name, value: value)
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        try await stream.write(name)
        try await stream.write(.equal)
        try await stream.write(value)
    }
}
