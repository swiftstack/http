import Stream
import Platform

extension Int {
    static func decode<T: StreamReader>(from stream: T) async throws -> Self? {
        let result = try await stream.read(while: { $0 >= .zero && $0 <= .nine })
        { bytes -> Optional<Int> in
            guard bytes.count > 0 else {
                return nil
            }
            var value = 0
            for byte in bytes {
                value *= 10
                value += Int(byte - .zero)
            }
            return value
        }
        guard let integer = result else {
            return nil
        }
        return integer
    }
}

extension Double {
    static func decode<T: StreamReader>(from stream: T) async throws -> Self? {
        var string = [UInt8]()

        try await stream.read(while: { $0 >= .zero && $0 <= .nine }) { bytes in
            string.append(contentsOf: bytes)
        }

        if let result = try? await stream.consume(.dot), result == true {
            string.append(.dot)
            try await stream.read(while: { $0 >= .zero && $0 <= .nine }) { bytes in
                string.append(contentsOf: bytes)
            }
        }

        string.append(0)
        return strtod(unsafeBitCast(string, to: [Int8].self), nil)
    }
}
