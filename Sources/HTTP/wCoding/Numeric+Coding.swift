import Stream
import Platform

extension Int {
    init?<T: UnsafeStreamReader>(from stream: T) throws {
        let bytes = try stream.read(while: { $0 >= .zero && $0 <= .nine })
        guard bytes.count > 0 else {
            return nil
        }
        var value = 0
        for byte in bytes {
            value *= 10
            value += Int(byte - .zero)
        }
        self = value
    }
}

extension Double {
    init?<T: UnsafeStreamReader>(from stream: T) throws {
        var string = [UInt8]()

        let bytes = try stream.read(while: { $0 >= .zero && $0 <= .nine })
        string.append(contentsOf: bytes)

        if (try? stream.consume(.dot)) ?? false {
            string.append(.dot)
            let bytes = try stream.read(while: { $0 >= .zero && $0 <= .nine })
            string.append(contentsOf: bytes)
        }
        string.append(0)

        let pointer = UnsafeRawPointer(string)
            .assumingMemoryBound(to: Int8.self)
        self = strtod(pointer, nil)
    }
}
