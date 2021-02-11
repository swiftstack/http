import Stream

extension URL {
    func encode<T: StreamWriter>(
        _ key: PartialKeyPath<URL>,
        to stream: T) async throws
    {
        switch key {
        case \URL.path:
            let escaped = URL.encode(path, allowedCharacters: .pathAllowed)
            try await stream.write(escaped)
        case \URL.query:
            if let query = self.query, query.values.count > 0 {
                try await stream.write(.questionMark)
                try await query.encode(to: stream)
            }
        default:
            fatalError("unimplemented")
        }
    }
}

extension URL.Query {
    // FIXME: remove
    // FIXME: [Concurrency]
    func encode() -> [UInt8] {
        var result = [UInt8]()
        
        var isFirst = true
        for (key, value) in values {
            switch isFirst {
            case true: isFirst = false
            case false: result.append(.ampersand)
            }

            result.append(contentsOf: URL.encode(key, allowedCharacters: .queryPartAllowed))
            result.append(.equal)
            result.append(contentsOf: URL.encode(value, allowedCharacters: .queryPartAllowed))
        }
        
        return result
    }

    func encode<T: StreamWriter>(to stream: T) async throws {
        var isFirst = true
        for (key, value) in values {
            switch isFirst {
            case true: isFirst = false
            case false: try await stream.write(.ampersand)
            }

            try await stream.write(URL.encode(key, allowedCharacters: .queryPartAllowed))
            try await stream.write(.equal)
            try await stream.write(URL.encode(value, allowedCharacters: .queryPartAllowed))
        }
    }
}

extension URL.Host {
    func encode<T: StreamWriter>(to stream: T) async throws {
        try await stream.write(Punycode.encode(domain: address))
        if let port = port {
            try await stream.write(":\(port)")
            // FIXME: [Concurrency] build crash
            // try await stream.write(.colon)
            // try await stream.write("\(port)")
        }
    }
}
