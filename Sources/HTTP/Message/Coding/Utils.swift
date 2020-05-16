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
    init(_ value: String) {
        self = [UInt8](value.utf8)
    }
}

// MARK: Numeric parsers

extension Int {
    init?<T: RandomAccessCollection>(from bytes: T, radix: Int)
        where T.Element == UInt8, T.Index == Int {
        for byte in bytes {
            guard (byte >= .zero && byte <= .nine)
            || (byte | 0x20) >= .a && (byte | 0x20) <= .f else {
                return nil
            }
        }
        // FIXME: validate using hex table or parse manually
        let string = String(decoding: bytes, as: UTF8.self)
        self.init(string, radix: radix)
    }
}

// MARK: UnsafeRawBufferPointer extension

extension Collection where Element == UInt8, Index == Int {
    @inline(__always)
    func trimmingLeftSpace() -> SubSequence {
        if startIndex < endIndex && self[startIndex] == .whitespace {
            return self.dropFirst()
        }
        return self[...]
    }

    @inline(__always)
    func trimmingRightSpace() -> SubSequence {
        if startIndex < endIndex && self[endIndex-1] == .whitespace {
            return self.dropLast()
        }
        return self[...]
    }
}

extension UnsafeRawBufferPointer {
    var debugString: String {
        return String(decoding: self, as: UTF8.self)
    }
}
