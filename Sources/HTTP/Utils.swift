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
    init?<T: RandomAccessCollection>(ascii bytes: T)
        where T.Element == UInt8, T.Index == Int {
        self.init(validating: bytes, as: .ascii)
    }

    init?<T: RandomAccessCollection>(
        validating bytes: T,
        as characterSet: ASCIICharacterSet
    ) where T.Element == UInt8, T.Index == Int {
        for byte in bytes {
            guard byte != 0 && characterSet.contains(byte) else {
                return nil
            }
        }
        self = String(decoding: bytes, as: UTF8.self)
    }
}

// MARK: Numeric parsers

import Stream

extension Int {
    init?<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        let bytes = try stream.read(while: { $0 >= .zero && $0 <= .nine })
        guard bytes.count > 0 else {
            return nil
        }
        var port = 0
        for byte in bytes {
            port *= 10
            port += Int(byte - .zero)
        }
        self = port
    }
}

extension Int {
    init?<T: RandomAccessCollection>(from bytes: T, radix: Int)
        where T.Element == UInt8, T.Index == Int {
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
        let string = String(decoding: bytes, as: UTF8.self)
        self.init(string, radix: radix)
    }
}

extension Double {
    init?<T: RandomAccessCollection>(from bytes: T)
        where T.Element == UInt8, T.Index == Int {
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
