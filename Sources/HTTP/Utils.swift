// MARK: Hash

extension Sequence where Iterator.Element == UInt8 {
    public var lowercasedHashValue: Int {
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
    @inline(__always)
    public init(_ value: String) {
        self = [UInt8](value.utf8)
    }
}

extension UInt8: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(ascii: value.unicodeScalars.first!)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(ascii: value.unicodeScalars.first!)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(ascii: value.unicodeScalars.first!)
    }
}

// MARK: String initializer from byte sequence (without null terminator)

extension String {
    public init(buffer: UnsafeRawBufferPointer) {
        _debugPrecondition(!buffer.contains(0), "invalid data")
        let count = buffer.count
        let storage = _StringBuffer(
            capacity: count,
            initialSize: count,
            elementWidth: 1)
        storage.start.copyBytes(from: buffer.baseAddress!, count: count)
        self = String(_storage: storage)
    }

    public init(buffer: UnsafeRawBufferPointer.SubSequence) {
        self.init(buffer: UnsafeRawBufferPointer(rebasing: buffer))
    }

    public init(bytes: [UInt8]) {
        self = String(
            buffer: UnsafeRawBufferPointer(start: bytes, count: bytes.count))
    }
}

// MARK: UnsafeRawBufferPointer extension

extension RandomAccessSlice where Element == UInt8, Base.Index == Int {
    @inline(__always)
    func index(of element: UInt8, offset: Int) -> Int? {
        guard let index = self[offset...].index(of: element) else {
            return nil
        }
        return index
    }
}

extension RandomAccessSlice where Element == UInt8, Base.Index == Int {
    @inline(__always)
    func trimmingLeftSpace() -> RandomAccessSlice<Base> {
        if startIndex < endIndex && self[startIndex] == Character.whitespace {
            return self.dropFirst()
        }
        return self
    }

    @inline(__always)
    func trimmingRightSpace() -> RandomAccessSlice<Base> {
        if startIndex < endIndex && self[endIndex-1] == Character.whitespace {
            return self.dropLast()
        }
        return self
    }
}
