public struct Accept {
    public let mediaType: MediaType
    public let priority: Double

    public init(_ mediaType: MediaType, priority: Double = 1.0) {
        self.mediaType = mediaType
        self.priority = priority
    }
}

extension Accept: Equatable {
    public static func ==(lhs: Accept, rhs: Accept) -> Bool {
        return lhs.mediaType == rhs.mediaType &&
            lhs.priority == rhs.priority
    }
}

extension Array where Element == Accept {
    init(from bytes: UnsafeRawBufferPointer) throws {
        var startIndex = 0
        var endIndex = 0
        var values = [Accept]()
        while endIndex < bytes.endIndex {
            endIndex =
                bytes.index(of: Character.comma, offset: startIndex) ??
                bytes.endIndex
            values.append(try Accept(from: bytes[startIndex..<endIndex]))
            startIndex = endIndex.advanced(by: 1)
            if startIndex < bytes.endIndex &&
                bytes[startIndex] == Character.whitespace {
                    startIndex += 1
            }
        }
        self = values
    }

    func encode(to buffer: inout [UInt8]) {
        for i in startIndex..<endIndex {
            if i != startIndex {
                buffer.append(Character.comma)
            }
            self[i].encode(to: &buffer)
        }
    }
}

extension Accept {
    private struct Bytes {
        static let qEqual = ASCII("q=")
    }

    init(from bytes: UnsafeRawBufferPointer) throws {
        if let semicolon = bytes.index(of: Character.semicolon, offset: 0) {
            self.mediaType = try MediaType(from: bytes.prefix(upTo: semicolon))

            let priorityBytes = bytes.suffix(from: semicolon.advanced(by: 1))
            guard priorityBytes.count == 5,
                priorityBytes.starts(with: Bytes.qEqual),
                let priority = Double(
                    String(buffer: priorityBytes.suffix(from: 2))) else {
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
            buffer.append(Character.semicolon)
            buffer.append(contentsOf: Bytes.qEqual)
            buffer.append(contentsOf: [UInt8](String(describing: priority)))
        }
    }
}
