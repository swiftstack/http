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

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        var startIndex = bytes.startIndex
        var endIndex = startIndex
        var values = [Accept]()
        while endIndex < bytes.endIndex {
            endIndex =
                bytes.index(of: .comma, offset: startIndex) ??
                bytes.endIndex
            values.append(try Accept(from: bytes[startIndex..<endIndex]))
            startIndex = endIndex.advanced(by: 1)
            if startIndex < bytes.endIndex &&
                bytes[startIndex] == .whitespace {
                    startIndex += 1
            }
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

    init(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) throws {
        if let semicolon = bytes.index(of: .semicolon) {
            self.mediaType = try MediaType(from: bytes[..<semicolon])

            let index = semicolon.advanced(by: 1)
            let bytes = UnsafeRawBufferPointer(rebasing: bytes[index...])
            guard bytes.count == 5,
                bytes.starts(with: Bytes.qEqual),
                let priority = Double(from: bytes[2...]) else {
                    throw HTTPError.invalidHeaderValue
            }
            self.priority = priority
        } else {
            self.mediaType = try MediaType(from: bytes)
            self.priority = 1.0
        }
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
