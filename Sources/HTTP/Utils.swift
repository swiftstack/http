// MARK: Hash

extension Sequence where Iterator.Element == UInt8 {
    public var hashValue: Int {
        var hash = 5381
        for byte in self {
            hash = ((hash << 5) &+ hash) &+ Int(byte | 0x20)
        }
        return hash
    }
}

// MARK: ASCII

typealias ASCII = [UInt8]
extension Array where Element == UInt8 {
    public init(_ value: String) {
        self = [UInt8](value.utf8)
    }
}

extension UInt8: ExpressibleByStringLiteral {
    private init(_ value: String) {
        self = ASCII(value.utf8)[0]
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}

// MARK: Safe String parsing


extension String {
    public init(buffer: UnsafeRawBufferPointer) {
        self = String(cString: [UInt8](buffer) + [0])
    }
    public init(bytes: [UInt8]) {
        self = String(cString: bytes + [0])
    }
}

// MARK: UnsafeRawBufferPointer extension

extension UnsafeRawBufferPointer {
    @inline(__always)
    func index(of element: UInt8, offset: Int) throws -> Int {
        guard let index = self.suffix(from: offset).index(of: element) else {
            throw RequestError.unexpectedEnd
        }
        return index + offset
    }
}
