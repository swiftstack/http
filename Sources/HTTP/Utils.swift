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
    public init?(ascii: UnsafeRawBufferPointer) {
        self.init(validating: ascii, as: .ascii)
    }

    public init?(ascii: UnsafeRawBufferPointer.SubSequence) {
        self.init(validating: ascii, as: .ascii)
    }

    public init?(ascii: [UInt8]) {
        self.init(validating: ascii, as: .ascii)
    }

    public init?(
        validating bytes: UnsafeRawBufferPointer,
        as characterSet: ASCIICharacterSet
    ) {
        for byte in bytes {
            guard byte != 0 && characterSet.contains(byte) else {
                return nil
            }
        }

        let count = bytes.count
        let storage = _StringBuffer(
            capacity: count,
            initialSize: count,
            elementWidth: 1)
        storage.start.copyBytes(from: bytes.baseAddress!, count: count)
        self = String(_storage: storage)
    }

    public init?(
        validating bytes: UnsafeRawBufferPointer.SubSequence,
        as characterSet: ASCIICharacterSet
    ) {
        self.init(
            validating: UnsafeRawBufferPointer(rebasing: bytes),
            as: characterSet
        )
    }

    public init?(
        validating bytes: [UInt8],
        as characterSet: ASCIICharacterSet
    ) {
        self.init(
            validating: UnsafeRawBufferPointer(
                start: bytes, count: bytes.count),
            as: characterSet
        )
    }
}

// MARK: Numeric parsers

extension Int {
    init?(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) {
        var result = 0
        let zero = 48
        let nine = 57
        for byte in bytes {
            guard byte >= zero && byte <= nine else {
                return nil
            }
            result *= 10
            result += Int(byte) - zero
        }
        self = result
    }

    init?(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>, radix: Int) {
        let zero = 48
        let nine = 57
        let a = 97
        let f = 102
        for byte in bytes {
            guard (byte >= zero && byte <= nine)
            || (byte | 0x20) >= a && (byte | 0x20) <= f else {
                return nil
            }
        }
        // FIXME: validate using hex table or parse manually
        let string = String(validating: bytes, as: .text)!
        self.init(string, radix: radix)
    }
}

extension Double {
    init?(from bytes: RandomAccessSlice<UnsafeRawBufferPointer>) {
        let dot = 46
        let zero = 48
        let nine = 57
        var integer: Int = 0
        var fractional: Int = 0
        var isFractional = false
        for byte in bytes {
            guard (byte >= zero && byte <= nine)
                || (byte == dot && !isFractional) else {
                    return nil
            }
            if byte == dot {
                isFractional = true
                continue
            }
            switch isFractional {
            case false:
                integer *= 10
                integer += Int(byte) - zero
            case true:
                fractional *= 10
                fractional += Int(byte) - zero
            }
        }
        let del: Int
        switch fractional % 10 {
        case 0:
            del = fractional * 10
        default:
            del = (fractional / 10 + 1) * 10
        }
        self = Double(integer) + Double(fractional) / Double(del)
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
