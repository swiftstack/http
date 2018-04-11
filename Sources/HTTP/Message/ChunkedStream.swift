import Stream

class ChunkedStreamWriter: StreamWriter {
    let baseStream: StreamWriter

    init(baseStream: StreamWriter) {
        self.baseStream = baseStream
    }

    func write(_ bytes: UnsafeRawPointer, byteCount: Int) throws {
        try baseStream.write(String(byteCount, radix: 16))
        try baseStream.write(Constants.lineEnd)
        try baseStream.write(bytes, byteCount: byteCount)
        try baseStream.write(Constants.lineEnd)
    }

    func write(_ byte: UInt8) throws {
        var copy = byte
        try write(&copy, byteCount: 1)
    }

    func write<T: BinaryInteger>(_ value: T) throws {
        var copy = value
        try write(&copy, byteCount: MemoryLayout<T>.size)
    }

    func flush() throws {
        try baseStream.flush()
    }

    func close() throws {
        try baseStream.write("0\r\n\r\n")
    }
}

class ChunkedInputStream: InputStream {
    let baseStream: StreamReader

    init(baseStream: StreamReader) {
        self.baseStream = baseStream
    }

    var closed = false
    var currentChunkBytesLeft = 0

    func readNextChunkSize() throws -> Int {
        let size = try baseStream.read(until: .cr) { bytes -> Int in
            guard let size = Int(from: bytes, radix: 16) else {
                throw ParseError.invalidRequest
            }
            return size
        }
        try readLineEnd()
        return size
    }

    func read(
        to pointer: UnsafeMutableRawPointer,
        byteCount requested: Int
    ) throws -> Int {
        guard !closed else {
            return 0
        }

        @inline(__always)
        func read(byteCount: Int, offset: Int = 0) throws {
            try baseStream.read(count: byteCount) { bytes in
                pointer
                    .advanced(by: offset)
                    .copyMemory(
                        from: bytes.baseAddress!,
                        byteCount: bytes.count)
            }
        }

        if currentChunkBytesLeft > requested {
            try read(byteCount: requested)
            currentChunkBytesLeft -= requested
            return requested
        }

        var remaining = requested
        if currentChunkBytesLeft > 0 {
            try read(byteCount: currentChunkBytesLeft)
            remaining -= currentChunkBytesLeft
            currentChunkBytesLeft = 0
            try readLineEnd()
        }

        while remaining > 0 {
            currentChunkBytesLeft = try readNextChunkSize()
            guard currentChunkBytesLeft > 0 else {
                try readLineEnd()
                closed = true
                return requested - remaining
            }
            let count = min(remaining, currentChunkBytesLeft)
            try read(byteCount: count, offset: requested - remaining)
            if currentChunkBytesLeft <= remaining {
                try readLineEnd()
            }
            remaining -= count
        }

        return requested
    }

    func close() throws {
        guard !closed else {
            return
        }
        if currentChunkBytesLeft > 0 {
            try baseStream.consume(count: currentChunkBytesLeft)
            currentChunkBytesLeft = 0
        }
        while true {
            let size = try readNextChunkSize()
            guard size > 0 else {
                try readLineEnd()
                closed = true
                break
            }
            try baseStream.consume(count: size)
        }
    }

    @inline(__always)
    func readLineEnd() throws {
        guard try baseStream.consume(.cr),
            try baseStream.consume(.lf) else {
                throw ParseError.invalidRequest
        }
    }
}

class ChunkedStreamReader: StreamReader {
    let baseStream: BufferedInputStream<ChunkedInputStream>

    init(baseStream: StreamReader) {
        self.baseStream = BufferedInputStream(
            baseStream: ChunkedInputStream(baseStream: baseStream),
            capacity: 4096)
    }

    func close() throws {
        try baseStream.baseStream.close()
    }

    var buffered: Int {
        return baseStream.buffered
    }

    func cache(count: Int) throws -> Bool {
        return try baseStream.cache(count: count)
    }

    func peek() throws -> UInt8 {
        return try baseStream.peek()
    }

    func peek<T>(
        count: Int, body: (UnsafeRawBufferPointer) throws -> T) throws -> T
    {
        return try baseStream.peek(count: count, body: body)
    }

    func read(_ type: UInt8.Type) throws -> UInt8 {
        return try baseStream.read(UInt8.self)
    }

    func read<T: FixedWidthInteger>(_ type: T.Type) throws -> T {
        return try baseStream.read(type)
    }

    func read<T>(
        count: Int,
        body: (UnsafeRawBufferPointer) throws -> T) throws -> T
    {
        return try baseStream.read(count: count, body: body)
    }

    func read<T>(
        mode: PredicateMode,
        while predicate: (UInt8) -> Bool,
        body: (UnsafeRawBufferPointer) throws -> T) throws -> T
    {
        return try baseStream.read(
            mode: mode,
            while: predicate,
            body: body)
    }

    func consume(count: Int) throws {
        try baseStream.consume(count: count)
    }

    func consume(_ byte: UInt8) throws -> Bool {
        return try baseStream.consume(byte)
    }

    func consume(mode: PredicateMode, while predicate: (UInt8) -> Bool) throws {
        return try baseStream.consume(mode: mode, while: predicate)
    }
}
