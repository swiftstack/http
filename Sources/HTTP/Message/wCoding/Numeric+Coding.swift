import Stream
import Platform

extension Int {
    init?<T: StreamReader>(from stream: T) throws {
        let result = try stream.read(while: { $0 >= .zero && $0 <= .nine })
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
        self = integer
    }
}

extension Double {
    init?<T: StreamReader>(from stream: T) throws {
        var string = [UInt8]()

        try stream.read(while: { $0 >= .zero && $0 <= .nine }) { bytes in
            string.append(contentsOf: bytes)
        }

        if (try? stream.consume(.dot)) ?? false {
            string.append(.dot)
            try stream.read(while: { $0 >= .zero && $0 <= .nine }) { bytes in
                string.append(contentsOf: bytes)
            }
        }
        string.append(0)

        let pointer = UnsafeRawPointer(string)
        self = strtod(pointer.assumingMemoryBound(to: Int8.self), nil)
    }
}
