import Stream

extension BufferedInputStream {
    func consume(sequence: [UInt8]) throws -> Bool {
        guard let buffer = try peek(count: sequence.count) else {
            throw StreamError.insufficientData
        }
        guard buffer.elementsEqual(sequence) else {
            return false
        }
        try consume(count: sequence.count)
        return true
    }
}

extension BufferedOutputStream {
    @inline(__always)
    func write(_ string: String) throws {
        let bytes = [UInt8](string.utf8)
        try write(bytes)
    }

    @inline(__always)
    func write(_ bytes: [UInt8]) throws {
        guard try write(bytes, byteCount: bytes.count) == bytes.count else {
            throw StreamError.notEnoughSpace
        }
    }
}