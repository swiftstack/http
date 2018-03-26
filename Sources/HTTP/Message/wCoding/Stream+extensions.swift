import Stream

extension StreamWriter {
    @inline(__always)
    func write(_ string: String) throws {
        let bytes = [UInt8](string.utf8)
        try write(bytes)
    }

    @inline(__always)
    func write(_ bytes: [UInt8]) throws {
        try write(bytes, byteCount: bytes.count)
    }
}
