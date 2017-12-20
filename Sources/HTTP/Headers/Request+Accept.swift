import Stream

extension Request {
    public struct Accept {
        public let mediaType: MediaType
        public let priority: Double

        public init(_ mediaType: MediaType, priority: Double = 1.0) {
            self.mediaType = mediaType
            self.priority = priority
        }
    }
}

extension Request.Accept: Equatable {
    public typealias Accept = Request.Accept
    public static func ==(lhs: Accept, rhs: Accept) -> Bool {
        return lhs.mediaType == rhs.mediaType &&
            lhs.priority == rhs.priority
    }
}

extension Array where Element == Request.Accept {
    public typealias Accept = Request.Accept

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        var values = [Accept]()
        
        while true {
            let value = try Accept(from: stream)
            values.append(value)
            guard try stream.consume(.comma) else {
                break
            }
            try stream.consume(while: { $0 == .whitespace })
        }
        self = values
    }

    func encode<T: OutputStream>(to stream: BufferedOutputStream<T>) throws {
        for i in startIndex..<endIndex {
            if i != startIndex {
                try stream.write(.comma)
            }
            try self[i].encode(to: stream)
        }
    }
}

extension Request.Accept {
    private struct Bytes {
        static let qEqual = ASCII("q=")
    }

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        self.mediaType = try MediaType(from: stream)

        guard try stream.consume(.semicolon) else {
            self.priority = 1.0
            return
        }

        guard try stream.consume(sequence: Bytes.qEqual) else {
            throw HTTPError.invalidAcceptHeader
        }

        guard let priority = try Double(from: stream) else {
            throw HTTPError.invalidAcceptHeader
        }
        self.priority = priority
    }

    func encode<T: OutputStream>(to stream: BufferedOutputStream<T>) throws {
        try mediaType.encode(to: stream)

        if priority < 1.0 {
            try stream.write(.semicolon)
            try stream.write(Bytes.qEqual)
            try stream.write([UInt8](String(describing: priority)))
        }
    }
}
