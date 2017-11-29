extension StringProtocol {
    fileprivate var isPunycode: Bool {
        return starts(with: Punycode.prefix)
    }

    fileprivate var isASCII: Bool {
        for unicodeScalar in self.unicodeScalars {
            guard unicodeScalar.isASCII else {
                return false
            }
        }
        return true
    }
}

extension Punycode {
    public static func encode(domain: String) -> String {
        if domain.isASCII || domain.isPunycode {
            return domain
        }
        var parts = domain.components(separatedBy: ".")
        for (index, part) in parts.enumerated() {
            guard !part.isASCII else {
                continue
            }
            parts[index] = encode(part)
        }
        return parts.joined(separator: ".")
    }

    public static func decode(domain: String) -> String {
        var parts = domain.components(separatedBy: ".")
        for (index, part) in parts.enumerated() {
            guard part.isPunycode else {
                continue
            }
            parts[index] = decode(part)
        }
        return parts.joined(separator: ".")
    }
}

public struct Punycode {
    public static let prefix = "xn--"

    private static let base = 36
    private static let tmin = 1
    private static let tmax = 26
    private static let skew = 38
    private static let damp = 700
    private static let initialBias = 72
    private static let initialN = 0x80
    private static let characters = [UInt8](
        "abcdefghijklmnopqrstuvwxyz0123456789".utf8)
    private static let asciiPrefix = [UInt8](prefix.utf8)

    private static func encode(digit index: Int) -> UInt8 {
        return characters[index]
    }

    private static func decode(character: UInt8) -> Int {
        let character = Int(character)
        switch character {
        case 48...57: return character - 22
        case 65...90: return character - 65
        case 97...122: return character - 97
        default: return base
        }
    }

    private static func adapt(
        delta: Int, numPoints: Int, firstTime: Bool
    ) -> Int {
        var delta = firstTime ? delta / damp : delta >> 1
        delta += delta / numPoints
        var k = 0
        while delta > ((base - tmin) * tmax) / 2 {
            delta /= base - tmin
            k += base
        }
        return k + (base - tmin + 1) * delta / (delta + skew)
    }

    private static func encode(_ input: String) -> String {
        let input = [UnicodeScalar](input.unicodeScalars)
        var output = asciiPrefix

        var handled = 0
        for unicodeScalar in input {
            if unicodeScalar.isASCII {
                output.append(UInt8(unicodeScalar.value))
                handled += 1
            }
        }
        let basic = handled
        if handled > 0 {
            output.append(.delimeter)
        }

        var n = initialN
        var delta = 0
        var bias = initialBias

        while handled < input.count {
            var m = Int.max
            for unicodeScalar in input {
                let value = Int(unicodeScalar.value)
                if value >= n && value < m {
                    m = value
                }
            }

            delta += (m - n) * (handled + 1)
            n = m

            for unicodeScalar in input {
                let value = Int(unicodeScalar.value)
                if value < n {
                    delta += 1
                    continue
                }
                guard value == n else {
                    continue
                }

                var q = delta
                var k = base
                while true {
                    let t: Int
                    switch k {
                    case ...bias: t = tmin
                    case (bias + tmax)...: t = tmax
                    default: t = k - bias
                    }

                    if q < t {
                        break
                    }

                    let code = t + (q - t) % (base - t)
                    output.append(encode(digit: code))
                    q = (q - t) / (base - t)
                    k += base
                }
                output.append(encode(digit: q))
                bias = adapt(
                    delta: delta,
                    numPoints: handled + 1,
                    firstTime: handled == basic)
                delta = 0
                handled += 1
            }

            delta += 1
            n += 1
        }

        return String(decoding: output, as: UTF8.self)
    }

    private static func decode(_ input: String) -> String {
        let input = [UInt8](input.utf8)
        var output = [UInt32]()

        var index = 4

        if let delimeter = input.lastIndex(of: .delimeter), delimeter > index {
            let basic = input[index..<delimeter].map { UInt32($0) }
            output.append(contentsOf: basic)
            index = delimeter + 1
        }

        var i = 0
        var n = initialN
        var bias = initialBias
        var outputCount = output.count

        while index < input.endIndex {
            let oldi = i
            var w = 1
            var k = base

            while true {
                let digit = decode(character: input[index])
                index += 1

                i += digit * w

                let t: Int
                switch k {
                case ...bias: t = tmin
                case (bias + tmax)...: t = tmax
                default: t = k - bias
                }

                if digit < t {
                    break
                }
                w *= base - t
                k += base
            }

            outputCount += 1
            bias = adapt(
                delta: i - oldi,
                numPoints: outputCount,
                firstTime: oldi == 0)

            n += i / outputCount
            i %= outputCount

            output.insert(UInt32(n), at: i)
            i += 1
        }

        return String(decoding: output, as: UTF32.self)
    }
}

extension UInt8 {
    static let delimeter = UInt8(ascii: "-")
}

extension RandomAccessCollection where Element: Equatable {
    @inline(__always)
    fileprivate func lastIndex(of element: Element) -> Index? {
        var index = self.index(before: endIndex)
        while index >= startIndex {
            if self[index] == element {
                return index
            }
            formIndex(before: &index)
        }
        return nil
    }
}
