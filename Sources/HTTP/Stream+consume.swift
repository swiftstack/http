import Stream

extension BufferedInputStream {
    func consume(_ byte: UInt8) throws -> Bool {
        guard let buffer = try peek(count: 1), buffer[0] == byte else {
            return false
        }
        try consume(count: 1)
        return true
    }

    func consume(sequence: [UInt8]) throws -> Bool {
        guard let buffer = try peek(count: sequence.count),
            buffer.elementsEqual(sequence) else {
                return false
        }
        try consume(count: sequence.count)
        return true
    }
}
