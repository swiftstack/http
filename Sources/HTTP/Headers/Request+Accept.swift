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

    func encode(to buffer: inout [UInt8]) {
        for i in startIndex..<endIndex {
            if i != startIndex {
                buffer.append(.comma)
            }
            self[i].encode(to: &buffer)
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

        // FIXME: implement Double(from stream:)
        let buffer = try stream.read(allowedBytes: .token)
        guard let priority = Double(from: buffer) else {
            throw HTTPError.invalidAcceptHeader
        }
        self.priority = priority
    }

    func encode(to buffer: inout [UInt8]) {
        mediaType.encode(to: &buffer)

        if priority < 1.0 {
            buffer.append(.semicolon)
            buffer.append(contentsOf: Bytes.qEqual)
            buffer.append(contentsOf: [UInt8](String(describing: priority)))
        }
    }
}
