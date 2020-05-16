import Stream

extension URL {
    func encode<T: StreamWriter>(
        _ key: PartialKeyPath<URL>,
        to stream: T) throws
    {
        switch key {
        case \URL.path:
            let escaped = URL.encode(path, allowedCharacters: .pathAllowed)
            try stream.write(escaped)
        case \URL.query:
            if let query = self.query, query.values.count > 0 {
                try stream.write(.questionMark)
                try query.encode(to: stream)
            }
        default:
            fatalError("unimplemented")
        }
    }
}

extension URL.Query {
    // FIXME: remove
    func encode() -> [UInt8] {
        let stream = OutputByteStream()
        try! encode(to: stream)
        return stream.bytes
    }

    func encode<T: StreamWriter>(to stream: T) throws {
        var isFirst = true
        for (key, value) in values {
            switch isFirst {
            case true: isFirst = false
            case false: try stream.write(.ampersand)
            }

            try stream.write(URL.encode(key, allowedCharacters: .queryPartAllowed))
            try stream.write(.equal)
            try stream.write(URL.encode(value, allowedCharacters: .queryPartAllowed))
        }
    }
}

extension URL.Host {
    func encode<T: StreamWriter>(to stream: T) throws {
        try stream.write(Punycode.encode(domain: address))
        if let port = port {
            try stream.write(.colon)
            try stream.write("\(port)")
        }
    }
}
